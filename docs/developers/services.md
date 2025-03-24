# Services (Dienste)

Ein Dienst abstrahiert die Geschäftslogik einer Anwendung vom Controller. Er wird verwendet, um Operationen in der
Datenbank durchzuführen, wie z.B. das Erstellen, Löschen oder Bearbeiten von Entitäten. Dienste werden verwendet, um Controller sauber zu halten und um die
die Geschäftslogik von der Controller-Logik zu trennen.

### Beispiel

Ein Beispiel für einen Dienst könnte ein `UserService` sein, der Funktionen zum Erstellen, Löschen und Bearbeiten von Benutzern bereitstellt.
Der Service könnte dann in einem `UserController` verwendet werden, um Benutzer zu erstellen, zu löschen oder zu bearbeiten.

## Zugriff auf einen Service

Um auf einen Dienst zuzugreifen, muss er zunächst importiert werden. Dazu wird der folgende Code verwendet:

```PHP
use App\Services\UserService;
```

Funktionen des Dienstes können dann wie folgt aufgerufen werden:

```PHP
$exampleService = new ExampleService();
$result = $exampleService->exampleFunction();
```

## Beispiel

Ein Beispiel für eine Dienstmethode könnte so aussehen:

```PHP
  /**
   * Erstelle eine neue Buchbestellung.
   *
   * @param BookOrder $bookOrder Das zu persistierende Buchbestellungsobjekt
   * @return BookOrder Das persistierte Buchbestellungsobjekt
   * @throws Exception Wenn ein Fehler während der Transaktion auftritt
   */
  public function createBookOrder(BookOrder $bookOrder): BookOrder
  {
    $this->entityManager->persist($bookOrder);
    $this->entityManager->flush();
    return $bookOrder;
  }
```

::: tip TIPP
Bei der Erstellung von Methoden in einem Dienst ist es wichtig, daran zu denken, dass der Dienst nur Geschäftslogik enthalten sollte.
Es ist eine gute Praxis, dem Methodennamen die Aktion voranzustellen, die er ausführt.
:::

## Verwendung eines Service in einem Controller

Ein Service kann wie folgt in einem Controller verwendet werden:

```PHP{1,8,12}
use App\Service\BookOrderService;
// ...

#[Route("api/v1/bookOrders")]
class BookOrderController extends AbstractController
{
  #[Route(path: "/", methods: ["GET"])]
  public function getBooks(BookOrderService $bookOrderService): Response
  {
    // ...
    try {
      $bookOrders = $bookOrderService->getBookOrders();
      // ...
    } catch (Exception $e) {
      // ...
    }
  }
```

::: warning WARNUNG
Der Dienst **muss** das erste Argument in der Controller-Methode sein.
:::
