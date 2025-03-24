# An-/Abmeldung

Die Schulbuchaktion verwendet LDAP zur Authentifizierung.
Benutzername und Passwort werden nur zur Authentifizierung gegenüber dem LDAP-Server verwendet, d.h. es gibt keine Benutzerdatenbank-Tabelle.

## Bearer Token

Die Backend-API gibt nach einem Authentifizierungsversuch ein JWT-Token zurück.
Die Verschlüsselung des Tokens erfolgt mit dem Algorithmus `HS256`. Dafür verwenden wir die `jwt-decode` Bibliothek.

### Nutzdaten

Der Payload (ab `v0.12.1`) des Tokens enthält die folgenden Informationen:

```json {5}
{
  "id": 5,
  "username": "testuser",
  "role": "NOT_PERMITTED",
  "authenticated": true,
  "timeStamp": 1717410359
}
```

Das Feld `authenticated` wird verwendet, um festzustellen, ob der Benutzer authentifiziert ist oder nicht.
Sind Sie neugierig auf das Feld `role`? Besuchen Sie die Seite [Sicherheit](./security).

## Route Guard Middleware

Die `auth` Middleware wird verwendet, um Routen vor unberechtigtem Zugriff zu schützen.
In Nuxt wird sie global registriert und bei jeder Routenänderung ausgeführt.

```ts
// ...

// Umleitung zur Anmeldung, wenn nicht authentifiziert
if (!authenticated && to.path !== "/login") {
  return navigateTo("/login")
}

// verhindern, dass man zum Login gelangt, wenn man bereits authentifiziert ist
if (authenticated && to.path === "/login") {
  return navigateTo("/")
}

// ...
```

Lesen Sie unbedingt die [Dokumentation](https://nuxt.com/docs/guide/directory-structure/middleware) für weitere Informationen.
