# Documentation

Unten finden Sie eine einfache Anleitung zur Erweiterung der Dokumentation.

## Eine Gruppe zur Seitenleiste hinzufügen

Das Hinzufügen einer Gruppe in der Seitenleiste erfolgt in der Funktion `sidebarUsers()` oder `sidebarDevelopers()`
in `docs/.vitepress/en.ts` (Englisch)
und `docs/.vitepress/de.ts` (Deutsch) entsprechend.

Um eine neue Gruppe hinzuzufügen, müssen Sie ein neues Objekt zum Array hinzufügen:

```ts
function sidebarUsers(): DefaultTheme.SidebarItem[] {
  return [
    {
      text: "Introduction",
      collapsed: false,
      items: [
        {
          // ...
        },
      ],
    },
    { // [!code ++]
      text: "Donations", // [!code ++] // Gruppentitel
      collapsed: false, // [!code ++]  // auf true setzen, damit der Benutzer sie bei Bedarf öffnen kann
      items: [ // [!code ++]
        { // [!code ++]
          text: "Getting Started", // [!code ++] // Titel 
          link: "getting-started", // [!code ++] // entsprechende .md-Datei (Markdown-Datei), fügen Sie keine Dateierweiterung oder Pfad hinzu!
        }, // [!code ++]
      ], // [!code ++]
    }, // [!code ++]
  ]
}
```

Führen Sie dasselbe in `de.ts` aus und übersetzen Sie nur den **text**, ändern Sie nicht den `link`.

## Eine Markdown-Datei hinzufügen

Nachdem Sie die Seitenleistenlinks erstellt haben, müssen Sie jetzt die Markdown-Dateien erstellen. Die englischen
Versionen werden im Root-verzeichnis unter `/users` und `/developers` hinzugefügt, und die deutschen Versionen werden unter
`/de` hinzugefügt.

::: danger GEFAHR
Tote Links (fehlende Markdown-Dateien) führen zu einem Buildfehler!
:::