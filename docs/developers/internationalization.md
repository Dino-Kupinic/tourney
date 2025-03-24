# Internationalisierung

Derzeit unterstützt die Schulbuchaktion nur **Englisch** und **Deutsch**.
Für Übersetzungen nutzen wir die vue i18n Bibliothek und das entsprechende Nuxt Modul.

## Übersetzen

Die Lokalisierungen befinden sich in `/frontend/locales`. In diesem Verzeichnis befindet sich eine JSON-Datei für jede Sprache.
Kurzformen werden verwendet, um eine Sprache zu identifizieren, z.B. `en-US.json`.

### Hinzufügen einer neuen Sprache

Dies geschieht ganz einfach durch Hinzufügen einer neuen Datei in das Verzeichnis `/locales`.
Sie können die Datei `en-US.json` kopieren und die Felder ersetzen.

Als nächstes müssen Sie die Sprache zum Array `currentLocales` (`/frontend/config/i18n.ts`) hinzufügen.

```ts
export const currentLocales: LocaleObject[] = [
  {
    code: "en-US",
    file: "en-US.json",
    name: "English",
  },
  {
    code: "de-DE",
    file: "de-DE.json",
    name: "Deutsch",
  },
  { // [!code ++]
    code: "jp-JP", // [!code ++]
    file: "jp-JP.json", // [!code ++]
    name: "日本語", // [!code ++]
  }, // [!code ++]
]
```
