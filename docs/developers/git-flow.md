# Git Flow

Hier diskutieren wir die Branches und ihre Bedeutung.

## Branches

### Main Branches:

**Main**:
Stellt den produktionsbereiten Code dar. Nur stabiler, vollständig getesteter Code sollte in diesen Branch eingefügt
werden.

**Develop**:
Dient als Integrations-branch für Funktionen. Alle Feature-Branches werden letztendlich in diesen Zweig eingefügt.

### Support Branches:

**Feature branches**:
Werden zum Entwickeln neuer Funktionen oder Verbesserungen verwendet. Diese Branches werden vom Entwicklungs-Zweig
abgezweigt und werden nach Abschluss wieder in ihn eingefügt.

**Hotfix branches**:
Werden verwendet, um schnell kritische Fehler oder Probleme im Produktionscode zu beheben. Sie werden vom Main-branch
abgezweigt, behoben und dann sowohl in den Main- als auch in den Develop-branch eingefügt.