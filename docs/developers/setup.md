# Einrichten

## Installation für die Entwicklung

1. Klonen Sie das Repository:

```bash
git clone https://github.com/Dino-Kupinic/Schulbuchaktion.git
```

## Frontend

1. Wechseln Sie in das Frontend-Verzeichnis

```bash
cd frontend
```

2. Pakete installieren

```bash
pnpm i
```

::: tip TIPP
Wenn Sie pnpm nicht installiert haben, schauen Sie unter https://pnpm.io/installation nach, um es für Ihr Betriebssystem
zu installieren.
:::

3. Umgebungsvariablen definieren

Erstellen Sie eine `.env` Datei und schauen Sie sich die `.env.example` an. Kopiere Sie den Inhalt in ihre `.env` und
ersetzen Sie die folgenden Felder durch Ihre eigenen. Sie können auch einige bestehende Felder bearbeiten.

| Feld          | Beschreibung                                                                |
|---------------|-----------------------------------------------------------------------------|
| `BACKEND_URL` | URL zum Symfony Backend Server (z.B. `http://localhost:8000/api/v1` in dev) |

Achten Sie darauf, dass das Suffix `/api/v1` am Ende der URL enthalten ist. Diese Umgebungsvariable wird für die
Basis-URL für Fetch-Requests verwendet.

4. Starten Sie den Entwicklungs-Server

```bash
pnpm run dev
```

5. Gehe zu `http://localhost:3000/`

Wenn es funktioniert, super!

::: warning WARNUNG
Folgende Anweisung ist optional und kann übersprungen werden. Falls Sie langsames Internet haben, könnte es eine
Weile dauern bis Sie Chrome, Safari und Firefox installiert haben (~150 MB)
:::

6. Installiere playwright browser

```
npx playwright install
```

## Backend

1. Wechseln Sie in das Backend-Verzeichnis

```bash
cd ../backend
```

oder

```bash
cd backend
```

2. Umgebungsvariablen definieren

Erstellen Sie eine `.env` Datei und schauen Sie sich das `.env.example` an. Kopiere den Inhalt in deine `.env` und
ersetze
Sie die folgenden Felder durch Ihre eigenen. Sie können auch einige bestehende Felder bearbeiten.

| Feld                       | Beschreibung                                                                                                                                      |
|----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `APP_SECRET`               | Ein geheimer Schlüssel, der verwendet wird, um die Dienste Ihrer Anwendung zu sichern.                                                            |
| `SECRET_PASSWORD`          | Datenbank-Passwort                                                                                                                                |
| `USERNAME`                 | Datenbank-Benutzer                                                                                                                                |
| `BIND_PORT`                | Datenbank-Port                                                                                                                                    |
| `DATABASE_URL`             | Der URL-String zu Ihrer Datenbank. Es werden die oben genannten Umgebungsvariablen verwendet.                                                     |
| `LDAP_PORT`                | Der Port Ihres LDAP-Servers.                                                                                                                      |
| `LDAP_URL`                 | Die URL Ihres LDAP-Servers.                                                                                                                       |
| `LDAP_BASE`                | Die Basis Ihres LDAP-Servers. (`dc=schulbuchaktion,dc=env`)                                                                                       |
| `ROLES`                    | Zeichenkette getrennt mit Komma von allen Rollen (Standard `'SBA_ADMIN,SBA_LEHRER,SBA_FV,SBA_AV'`)                                                |
| `SBA_ADMIN`                | Gruppennummer der Admin-Gruppe. (Standard `500`)                                                                                                  |
| `SBA_LEHRER`               | Gruppennummer der Lehrergruppe. (Voreinstellung `501`)                                                                                            |
| `SBA_FV`                   | Gruppennummer der Fachverantwortlichen-Gruppe. (Voreinstellung `502`)                                                                             |
| `SBA_AV`                   | Gruppennummer der Abteilungsvorstands-Gruppe. (Voreinstellung `503`)                                                                              |
| `TOKEN_TIMEOUT`            | Wie lange ein Token gültig ist. (Voreinstellung `1800`)                                                                                           |
| `HOURS_AHEAD`              | Zeitzone (Voreinstellung `2`)                                                                                                                     |
| `JWT_SECRET_ABSOLUT_PATH`  | Der absolute Pfad zum privaten Schlüssel für das JWT.                                                                                             |
| `CORS_ALLOW_ORIGIN`        | Die Herkunft, die auf die API zugreifen darf. (Standardwert `localhost`)                                                                          |
| `TOKEN_NAME`               | Name des Cookies, der das Bearer-Token enthält (Standard BearerToken)                                                                             |
| `CADDY_MERCURE_JWT_SECRET` | Wird verwendet, um JWTs sicher für die Client-Authentifizierung und -Autorisierung in einer Caddy-Server-Konfiguration mit Mercure zu signieren.  |
| `TRUSTED_PROXIES`          | Gibt die IP-Adressen oder Bereiche von Proxys an, denen vertraut wird, die clientbezogenen Header in einer Serverkonfiguration korrekt zu setzen. |
| `TRUSTED_HOSTS`            | Gibt eine Liste von Hostnamen oder Mustern an, die als vertrauenswürdig gelten und Anfragen stellen dürfen.                                       |
| `CADDY_MERCURE_URL`        | Gibt die URL des von der Caddy-Server verwendeten Mercure-Hubs an.                                                                                |
| `CADDY_MERCURE_PUBLIC_URL` | Gibt die öffentlich zugängliche URL des Mercure-Hubs an.                                                                                          |
| `HTTP_PORT`                | Port, der für HTTP-Verbindungen geöffnet wird. (Standard `80`)                                                                                    |
| `HTTPS_PORT`               | Port, der für HTTPS-Verbindungen geöffnet wird. (Standard `443`)                                                                                  |
| `SHELL_VERBOSITY`          | Verbositätsgrad von Server und Symfony. (Standard `0`)                                                                                            |

::: danger GEFAHR
Für das `APP_SECRET` schauen Sie bitte
unter https://symfony.com/doc/current/reference/configuration/framework.html#secret für die
neuesten Anforderungen.
:::

3. Starten Sie Docker

```bash
docker compose up -d
```

::: tip TIPP
Wenn Sie Docker nicht installiert haben, schauen Sie unter https://www.docker.com/products/docker-desktop/, um es für
Ihr Betriebssystem zu installieren.
:::

4. Installieren Sie die Abhängigkeiten

```bash
composer update
```

::: danger GEFAHR
Wenn Sie Fehler erhalten, müssen Sie möglicherweise Module wie `ldap` oder `zip` in Ihrer `php.ini`-Datei
auskommentieren. Composer wird Ihnen sagen was zu tun ist.
:::

5. Starten Sie den Entwicklungs-Server

```bash
symfony server:start
```

::: warning WARNUNG
Wenn Sie symfony cli nicht installiert haben, schauen Sie unter https://symfony.com/download#step-1-install-symfony-cli
nach, um es
für Ihr Betriebssystem zu installieren.
:::

6. Rufen Sie `http://127.0.0.1:8000` auf.

## Docs

1. Wechseln Sie in das Verzeichnis docs

```bash
cd ../docs
```

oder

```bash
cd docs
```

2. Pakete installieren

```bash
pnpm i
```

::: tip TIPP
Wenn Sie pnpm nicht installiert haben, schauen Sie unter https://pnpm.io/installation nach, um es für Ihr Betriebssystem
zu installieren.
:::

3. Starten Sie den Entwicklungs-Server

```bash
pnpm run docs:dev
```

4. Gehen Sie zu `http://localhost:5173/`

