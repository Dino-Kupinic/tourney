# Authentifizierung

Schulbuchaktion verfügt über eine erstklassige Integration mit LDAP, d.h. Sie können denselben Benutzernamen und dasselbe Passwort verwenden, das Sie
für die Anmeldung bei Ihrem Schulkonto verwenden.

## Anmeldeseite

Hier werden Sie aufgefordert, Ihren Benutzernamen und Ihr Passwort einzugeben.

![Login-Light.png](/login-light.png)

Wenn Sie auf die Login-Schaltfläche klicken, werden Sie authentifiziert und zum Dashboard weitergeleitet.
Sie können nun Bücher bestellen, Ihre Bestellungen einsehen und das Budget verwalten (wenn Sie die entsprechenden Rechte haben) :tada:

::: info Info
Ihre Anmeldedaten werden nicht in der Datenbank gespeichert, sondern dienen der Authentifizierung gegenüber dem LDAP-Server.
Die Daten werden sicher mit [HTTPS](https://en.wikipedia.org/wiki/HTTPS) übertragen.
:::

## Abmelden

Sie können sich abmelden, indem Sie im Dropdown-Menü Ihres Profils auf "Abmelden" klicken.
Sie werden dann auf die Anmeldeseite weitergeleitet.
