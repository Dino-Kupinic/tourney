# Sicherheit
Der folgende Inhalt beschreibt, wie die Middleware und die Benutzerberechtigungen funktionieren.

## Berechtigung
Zur Überprüfung der Berechtigung wird die Datei `security.xml` verwendet. In diesem XML finden Sie die Berechtigung
für jede Gruppe, die in `.env` definiert sind. Sie können das XML in `/config/security/security.xml` finden
basierend auf Ihrem Projektstamm.

### Form
Die Tags für die Routen-Berechtigung sind in zwei Teile aufgeteilt. Der erste Teil ist der Name des Controllers
der im Tag `#[Route ...]` des Controllers definiert ist. Der zweite Teil ist der Name der Funktionen
des Controllers, die ebenfalls im `#[Route ...]`-Tag der Funktion definiert sind.
Die XML-Datei enthält die folgenden Tags:
+ groups --> root-tag
+ role --> Name der spezifischen Rolle (z.B. `<ADMIN_ROLE>`)
+ routes --> fester Tag, der alle Routen enthält (Kombination Controller/Funktion)
+ controller --> Name des Controllers (z.B. YearController ist `<year>`)
+ function --> Wert dieses Tags enthält den Funktionsnamen (z.B. getYear ist `<function>get</function>`)

### Generierung
Sie können die XML-Datei mit dem Befehl `php bin/console security:create-security-xml` generieren. Dieser Befehl
erzeugt die Datei `security.generated.xml` im security-config-Pfad.
Sie müssen die Datei in `security.xml` umbenennen oder kopieren.

:::danger
Dieser Befehl generiert eine XML-Datei mit allen Berechtigungen für jede Rolle. Sie müssen manuell Controller- oder Funktions-Tags löschen,
um einer bestimmten Rolle den Zugriff zu verweigern.
:::

### Beispiel
Folgende XML-Dateien stellen die Berechtigung für die Rollen `ADMIN` und `USER` dar.
`ADMIN` ist erlaubt für die Funktionen `get`, `update` und `delete` des Controllers `user`.
Die Rolle `USER` ist nur für die Funktion `info` erlaubt.
```XML
<?xml version="1.0" encoding="UTF-8" ?>
<groups>
  <ADMIN>
    <routes>
      <user>
        <function>get</function>
        <function>update</function>
        <function>delete</function>
      </user>
    </routes>
  </ADMIN>
  <USER>
    <routes>
      <user>
        <function>info</function>
      </user>
    </routes>
  </USER>
</groups>
```
