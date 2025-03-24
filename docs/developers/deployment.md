# Deployment

[[toc]]

## Docker

1. jede `.env` in `/frontend` und `/backend` richtig konfigurieren

2. jede **nginx**-Konfiguration überprüfen (und anpassen)

3. docker compose ausführen

```bash
docker compose up -d
```

::: tip Tipp
Wenn Sie Docker nicht installiert haben, schauen Sie unter https://www.docker.com/.
:::

4. In der Cloud oder Ihrer Container-Infrastruktur deployen :tada:

## Klassisch

Bauen Sie jeden Dienst separat und deployen Sie ihn ohne Docker.

### Frontend

::: info
Das Frontend arbeitet als "Single Page
Application" [SPA](https://nuxt.com/docs/guide/concepts/rendering#client-side-rendering).
:::

1. Generierung ausführen

```bash
pnpm run generate
```

::: tip TIPP
Wenn Sie pnpm nicht installiert haben, schauen Sie unter https://pnpm.io/installation nach, um es für Ihr Betriebssystem zu installieren.
:::

2. Überprüfen, ob alles wie erwartet funktioniert

```bash
pnpm run preview
```

3. Gehe zu `http://localhost:3000/`
4. Alle generierten Assets befinden sich in `./output/public`

::: tip TIPP
Weitere Informationen zum Deployen finden Sie unter https://nuxt.com/deploy
:::

### Backend

Die neuesten Informationen zur Bereitstellung von Symfony finden Sie
hier: https://symfony.com/doc/current/deployment.html#symfony-deployment-basics

### Docs

::: tip TIPP
Die Dokumentation verwendet das gleiche Prinzip wie das Frontend. Weitere
Infos: https://vitepress.dev/guide/what-is-vitepress#performance
:::

1. Build ausführen

```bash
pnpm run docs:build
```

::: tip TIPP
Wenn Sie pnpm nicht installiert haben, schauen Sie unter https://pnpm.io/installation nach, um es für Ihr Betriebssystem zu installieren.
:::

2. Überprüfen, ob alles wie erwartet funktioniert

```bash
pnpm run docs:preview
```

3. Gehe zu `http://localhost:4173/`
4. Alle generierten Assets befinden sich in `./vitepress/dist`

::: tip
Weitere Informationen zur Bereitstellung finden Sie unter https://vitepress.dev/guide/deploy
:::
