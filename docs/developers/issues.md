# Issues

Features, Verbesserungsanfragen und Fehlerberichte werden über GitHub-Issues erstellt. Jedes Problem wird anhand der
folgenden Labels eingestuft:

## Ebenen

Eine Ebene beschreibt die Dringlichkeit des Problems. Während Ebene 1 oft langweilige Dinge wie das Installieren von
etwas oder das Beheben eines Tippfehlers umfasst, sollte Ebene 5 sofort erledigt werden.

::: info Ebene 1 -> "Aufgabe"
Dies sind Aufgaben, die erledigt werden sollten, wenn nichts anderes zu tun ist. Sie sind in der Regel routinemäßige
oder banale Aufgaben, die zum reibungslosen Ablauf des täglichen Lebens oder der Arbeit beitragen. Obwohl sie nicht
dringend oder kritisch sind, erfordern sie dennoch Aufmerksamkeit, um Effizienz und Organisation aufrechtzuerhalten.
:::

::: tip Ebene 2 -> "Nice-to-have"
Diese Aufgaben gelten als optional und können hinzugefügt werden, wenn Zeit vorhanden ist. Sie verbessern oft die
Qualität oder Bequemlichkeit einer Situation, sind jedoch nicht unbedingt für eine sofortige Erledigung erforderlich.
Aufgaben der Ebene 2 können Aktivitäten umfassen, die die Effizienz verbessern, die Ästhetik verbessern oder zusätzliche
Funktionen bereitstellen.
:::

::: warning Ebene 3 -> "Beheben, wenn möglich"
Diese Ebene deutet auf Probleme hin, die behoben werden sollten, aber nicht als kritisch angesehen werden. Sie können
aufgeschoben werden, bis Aufgaben mit höherer Priorität erledigt sind, sollten jedoch nicht unbegrenzt ignoriert werden.
Aufgaben der Ebene 3 können kleinere Fehler, Verbesserungen der Benutzerfreundlichkeit oder nicht unbedingt
erforderliche Reparaturen umfassen.
:::

::: danger Ebene 4 -> "Wichtig"
Aufgaben auf dieser Ebene sind bedeutend und erfordern Aufmerksamkeit. Sie sind wesentlich für den reibungslosen
Betrieb, die Erfüllung von Zielen oder die Verhinderung weiterer Probleme. Obwohl nicht dringend, sollten sie
priorisiert und rechtzeitig angegangen werden, um Eskalationen oder negative Konsequenzen zu vermeiden.
:::

::: danger Ebene 5 -> "Dringend"
Diese Aufgaben erfordern sofortiges Handeln aufgrund ihrer kritischen Natur oder Zeitabhängigkeit. Sie beinhalten oft
Notfälle, Sicherheitsbedenken oder Situationen, in denen Verzögerungen zu erheblichen negativen Auswirkungen führen
können. Aufgaben der Ebene 5 sollten über alle anderen priorisiert und so schnell wie möglich angegangen werden, um
Risiken zu mindern oder dringende Probleme zu lösen.
:::

## Kategorien

Labels, um das Problem genauer zu beschreiben.

| Category                            | Description                                       |
|-------------------------------------|---------------------------------------------------|
| bug (Fehler)                        | etwas funktioniert nicht                          |
| i18n                                | Internationalisierung                             |
| a11y                                | Barrierefreiheit                                  |
| documentation                       | Verbesserungen oder Ergänzungen zur Dokumentation |
| enhancement (Verbesserung)          | Neue Funktion oder Anfrage                        |
| help wanted (Hilfe benötigt	)       | Zusätzliche Aufmerksamkeit erforderlich           |
| pending triage (Ausstehende Triage) | Die Wichtigkeit muss bewertet werden              |
| question (Frage)                    | Weitere Informationen werden angefordert          |
| feature                             | grundlegendes Feature                             |
| test                                | Testen                                            |
| wont fix (Wird nicht behoben)       | Daran wird nicht gearbeitet                       |

## Workflow

Ein Entwickler wählt ein Problem aus, erstellt einen Branch, in dem er nur an der Aufgabe arbeitet, und erstellt dann
einen Pull-Request. Nach erfolgreichem Zusammenführen wiederholt er den Vorgang.