# Code Stil

## Eslint & Prettier

Eslint und Prettier sind im `/frontend` ordner installiert.
In PHPStorm, Prettier kann so konfiguriert werden, dass beim speichern formatiert wird.

Prettier für PHP ist zurzeit nicht vollkommen funktionsfähig, deswegen sollen die Legacy Regeln befolgt werden.
Da dass `/docs` verzeichnis größtenteils nur Markdown beinhaltet, ist Prettier nicht wirklich nötig.

## Legacy

Folgende Sektion gilt nur vor unserem Umstieg auf ESLint/Prettier.

Der Code, der in Schulbuchaktion eingereicht wird, sollte diesen Richtlinien folgen:

- Eine leere Zeile sollte am Ende der Datei vorhanden sein.
- Leerzeichen statt Tabs verwenden.
- camelCase verwenden.

::: tip
Sie können in **PHPStorm** die Tastenkombination STRG + UMSCHALT + L verwenden, um Ihre Formatierungsoptionen
anzuwenden.
Sie sollten diese in Ihren Einstellungen konfigurieren.
:::

Sie sollten auch diese Einstellungen konfigurieren:

| Einstellung                | Wert                              |
|----------------------------|-----------------------------------|
| Einrückung                 | 2                                 |
| Doppelte Anführungszeichen | Immer                             |
| Abschließendes Komma       | Immer bei mehrzeiligen Ausdrücken |
| Semikolon                  | Nie (TypeScript)                  |

In TypeScript bevorzugen Sie Pfeilfunktionen und die `async/await`-Syntax.
