# Extending

Schulbuchaktion ist so konzipiert, dass es modular und leicht erweiterbar ist.
Darüber hinaus haben wir auch eine standardisierte Arbeitsweise (Git-Flow, GitHub-Projekte, Issues, Pull Requests usw.).

Es wird **dringend** empfohlen, diese Richtlinien zu befolgen.

## Lernen

Bevor Sie an Schulbuchaktion arbeiten, sollten Sie ein solides Verständnis für folgende Dinge haben:

::: info
Obwohl Sie die Grundlagen kennen sollten, müssen Sie nicht alles auswendig wissen.
Wichtige Themen sind fett markiert.
:::

#### Sprachen

- TypeScript (**JavaScript**)
- **PHP**

#### Frameworks & Bibliotheken

- **Vue 3**
- Nuxt 3
- Pinia
- Vue Router
- Vitest (Jest)
- Playwright
- Symfony

#### Werkzeuge

- Docker
- Vite
- Composer
- **Git**

Die Erweiterung der Dokumentation erfordert nur Kenntnisse in Markdown.

## Architektur

Schulbuchaktion verwendet die monolithische Architektur.
Das Repository enthält die folgenden Hauptverzeichnisse, `/frontend`, `/backend` und `/docs`.
Wie Sie sehen können, haben wir auch ein Monorepo anstelle einer Aufteilung der Dienste in separate Git-Repositories,
z.B. `Schulbuchaktion-client`, `Schulbuchaktion-backend`, …

### REST-API

In diesem Projekt fungiert Symfony ausschließlich als REST-API, ohne Twig-Templates bereitzustellen.

### Nuxt

Nuxt ist ein **Full-Stack**-Framework, das bedeutet, es kann sowohl für das Frontend als auch das Backend verwendet
werden.
Wir ignorieren das Verzeichnis `/server` und verwenden nur die Frontend-Funktionen von Nuxt.

## Containerisierung

Das gesamte Projekt ist in einer einzigen `docker-compose.yml` eingerichtet.
Die MySQL-Datenbank hat ein Volume (`mysql_data`), das in `/backend` eingebunden ist.

## Empfohlene IDE und Werkzeuge

Schulbuchaktion wurde in **PHPStorm** erstellt; es wird empfohlen, es auch zu verwenden, da es alles von Haus aus
bereitstellt.
Wenn Sie VSCode verwenden möchten, müssen Sie Ihre eigene `.vscode`-Konfiguration bereitstellen.
<br> NeoVim- und Vim-Benutzer sollten wissen, wie sie ihre Umgebung selbst konfigurieren können.

Für manuelle API-Tests verwenden wir **Postman**.

## Dependabot

Wir verwenden **Dependabot** von GitHub, um unsere Abhängigkeiten auf dem neuesten Stand zu halten.
Es ist so konfiguriert, dass es wöchentlich überprüft wird.

## CommitCheck

Wir verwenden den **CommitCheck**-Bot, um die korrekten Commit-Nachrichten zu überprüfen.
Er ist so konfiguriert, dass er den [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) folgt.

RegEx-Filter: `^(feat|fix|chore|docs|style|refactor|perf|test|build|ci|revert)(\([^\)]+\))?(\!)?\: .+`

## Designs

UI/UX-Designs werden in **Figma** erstellt.
Wenn Sie sich das ansehen möchten, hier ist
der [Link](https://www.figma.com/file/tq8UhxGHnaj2MaDZE0KuRQ/Schulbuchaktion?type=design&node-id=0%3A1&mode=design&t=RsFq3WRm9AgRYYKV-1).
Wir verwenden **NuxtUI** als Basis für die Komponenten.

## Konventionen

Besuchen Sie den Abschnitt [Konventionen](./code-style), um mehr zu erfahren.
