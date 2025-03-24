# XLSX-Import

## PHPSpreadsheet

Die Bibliothek **PHPSpreadsheet** wird zum Parsen der jährlichen Schulbuchaktion XLSX-Dateien verwendet.
Die Operationen werden über den `ImportService` durchgeführt.

Um die Leistung zu verbessern, wird der `BookBatchProcessorService` verwendet, um die Daten in Batches zu verarbeiten.

## Importieren

Die Datei wird nicht auf dem Server gespeichert, sondern direkt aus der Anfrage gelesen. Nach der Verarbeitung wird sie verworfen.

```php
$filePath = $uploadedFile->getPathname();
$data = $importService->parseFile($filePath);

// ...

unset($data[0]); // Kopfzeile entfernen
$importService->persist($data, $year);
```

## Jahr für den Import
Beim Importieren kann der Benutzer wählen, für welches Jahr der Import bestimmt ist.
Die möglichen Optionen für dieses Jahr reichen 2 Jahre zurück und 1 Jahr vor dem aktuellen Jahr.
Wenn das nächste Jahr noch nicht in der Datenbank vorhanden ist, wird es eingefügt.
Die Logik für diesen Prozess wird jedes Mal ausgeführt, wenn der Benutzer die Seite `/import` besucht.

Sie können den Bereich der Jahre, die ein Benutzer auswählen kann, im `YearsRepository` ändern,
indem Sie die Variable `$pastYears` oder den Parameter `setMaxResults` ändern:
```php
public function findAllForImport($currentYear): array
    {
      $vergangeneJahre = 2;

        return $this->createQueryBuilder('y')
            ->andWhere('y.year >= :val')
            ->setParameter('val', $aktuellesJahr - $vergangeneJahre)
            ->orderBy('y.year', 'ASC')
            ->setMaxResults(4)
            ->getQuery()
            ->getResult()
        ;
    }
```

## Re-Importieren

Wenn das ausgewählte Jahr bereits Daten enthält, werden alle Buchdaten gelöscht.
Der Import wird dann wie gewohnt gestartet.
Die Löschung erfolgt auch über die Stapelverarbeitung.

## Chunking

Bei der Batch-Verarbeitung werden die Einfügeanweisungen in Chunks gruppiert.
Sie können die Chunk-Größe im `ImportService` ändern:

```php
$chunkSize = 200;
$chunks = array_chunk($data, $chunkSize);
```
