# Einkaufszettel

Gemeinsamer Einkaufszettel für die Familie: Produkte nach Geschäft sortiert, mit üblichen Preisen, Angeboten, Markierungen und Kürzeln der Familienmitglieder. Läuft im Browser auf Handy und Tablet und lässt sich wie eine App auf den Home-Bildschirm legen.

- **Hosting:** GitHub Pages
- **Abgleich zwischen den Geräten:** Supabase (kostenloser Tarif)
- **Zugang:** über einen Familien-Link. Niemand braucht ein Konto.

## Benutzen

1. App öffnen und **Neue Familienliste anlegen** wählen.
2. Regler-Symbol oben rechts. Unter **Familien-Link** auf **Kopieren** oder **Per Nachricht senden** tippen und den Link an die Familie schicken.
3. Unter **Familie** ein Profil pro Person anlegen. Jedes Gerät fragt beim ersten Öffnen einmal „Wer kauft hier ein?“.
4. Auf dem Handy: Link öffnen, dann **Teilen → Zum Home-Bildschirm** (iPhone) bzw. **⋮ → Zum Startbildschirm hinzufügen** (Android). Fragt die App vom Home-Bildschirm aus noch einmal nach dem Link, füge ihn einmal ein.

## Technik

| Datei | Zweck |
| --- | --- |
| `index.html` | die App |
| `config.js` | Supabase-Adresse und öffentlicher Schlüssel |
| `supabase.sql` | Tabelle und Zugriffsfunktionen, einmal im SQL-Editor von Supabase ausführen |
| `sw.js`, `manifest.webmanifest`, `icon-*.png` | Start ohne Netz und Home-Bildschirm |

## Sicherheit

- Wer den Familien-Link kennt, kann die Liste sehen und ändern, wie bei einem geteilten Google-Docs-Link. Teile ihn nur innerhalb der Familie.
- Der Schlüssel in `config.js` ist der öffentliche Supabase-Schlüssel, der für den Browser gedacht ist. Direkter Zugriff auf die Tabelle ist gesperrt. Lesen und Schreiben geht nur über die Funktionen aus `supabase.sql`, und nur mit dem Schlüssel einer Familienliste.
