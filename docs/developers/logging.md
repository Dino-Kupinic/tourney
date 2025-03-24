# Protokollierung

Wir protokollieren nur die grundlegenden Dinge, wie z.B. den Zugriff auf die Routen, das Scheitern der Anmeldung oder die Aktionen auf Datensätze.
Wir verwenden die vorgegebene Logger-Schnittstelle `Monolog` und zwei selbst erstellte Kanäle namens `security` und `action`.
Sie können die Logs in Ihrem Backend unter `/var/log` einsehen.

## Arten von Logs

- `security.log` enthält alle relevanten Logs über Routenzugriffe, ungültige Token und Berechtigungsverletzungen.
- `action.log` enthält alle Protokolle über die Erstellung, Manipulation oder Löschung von Daten.

## Konfiguration

Alle Konfigurationen können in der `monolog.yaml`-Konfiguration gefunden werden, die sich in `/config/packages/` befindet.

