-- Datenbank für den Einkaufszettel.
-- Alle Daten liegen in einer Tabelle, auf die niemand direkt zugreifen darf.
-- Lesen und Schreiben geht nur über drei Funktionen, und nur mit dem Schlüssel aus dem Familien-Link.

create table if not exists public.ekz_docs (
  family     text        not null check (char_length(family) between 20 and 64),
  coll       text        not null check (coll in ('stores', 'catalog', 'list', 'profiles')),
  id         text        not null check (char_length(id) between 1 and 100),
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (family, coll, id)
);

alter table public.ekz_docs enable row level security;
revoke all on table public.ekz_docs from anon, authenticated;

create or replace function public.ekz_pull(fam text)
returns table (coll text, id text, data jsonb)
language sql
stable
security definer
set search_path = public
as $$
  select d.coll, d.id, d.data
  from public.ekz_docs d
  where char_length(fam) >= 20 and d.family = fam;
$$;

create or replace function public.ekz_put(fam text, p_coll text, p_id text, p_data jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if char_length(fam) < 20 or char_length(fam) > 64 then
    raise exception 'invalid family' using errcode = '22023';
  end if;
  if pg_column_size(p_data) > 20000 then
    raise exception 'document too large' using errcode = '22023';
  end if;
  insert into public.ekz_docs (family, coll, id, data, updated_at)
  values (fam, p_coll, p_id, p_data, now())
  on conflict (family, coll, id) do update set data = excluded.data, updated_at = now();
end;
$$;

create or replace function public.ekz_del(fam text, p_coll text, p_id text)
returns void
language sql
security definer
set search_path = public
as $$
  delete from public.ekz_docs
  where char_length(fam) >= 20 and family = fam and coll = p_coll and id = p_id;
$$;

revoke all on function public.ekz_pull(text) from public;
revoke all on function public.ekz_put(text, text, text, jsonb) from public;
revoke all on function public.ekz_del(text, text, text) from public;
grant execute on function public.ekz_pull(text) to anon, authenticated;
grant execute on function public.ekz_put(text, text, text, jsonb) to anon, authenticated;
grant execute on function public.ekz_del(text, text, text) to anon, authenticated;
