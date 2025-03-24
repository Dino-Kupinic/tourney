# Database

## ER-Diagram
Das ER-Diagram wurde mit dem Webtool GenMyModel erstellt.

![er-diagram.png](/er-diagram.png)


## Umsetzung in Symfony
Die Datenbank wurde mit Doctrine ORM in Symfony umgesetzt. Die Entitäten wurden mit dem Befehl `php bin/console make:entity` erstellt. Die Entitäten wurden dann mit dem Befehl `php bin/console make:migration` in eine Migration umgewandelt. Die Migration wurde dann mit dem Befehl `php bin/console doctrine:migrations:migrate` in die Datenbank übertragen.
