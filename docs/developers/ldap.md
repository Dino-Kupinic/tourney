# LDAP
::: info
Die LDAP-Authentifizierung verbindet sich mit dem Server, der in der .env-Datei angegeben ist, und versucht
den angegebenen Benutzer in Kombination mit dem angegebenen Passwort zu authentifizieren. Die Authentifizierung wird
eine Rückmeldung [JWT](https://jwt.io).
:::

## LoginController

### Übersicht
Der `LoginController` ist ein Symfony-Controller, der für die Bearbeitung von Authentifizierungsanfragen zuständig ist. Er enthält eine Action
Methode `index()`, die auf die Route `/ldaps` abgebildet ist. Diese authentifiziert Benutzer und generiert dementsprechende Authentifizierungs-Token.

### Code Auszug
```php
class LoginController extends AbstractController
{
  #[Route('/ldaps', name: 'app_ldap')]
  public function index(AuthService $authService, Request $request, Kernel $kernel): Response
  {
    $user = $request->get("usr");
    $pwd = $request->get("pwd");
    $status = $authService->authenticateUser($user, $pwd);

    $key = file_get_contents($kernel->getProjectDir() . "/config/jwt/private.pem");
    $token = new AuthToken($key);
    $token->setValue(['user' => $user, 'authorized' => $status]);

    return new JsonResponse($token, 200, [], true);
  }
}
```

### Funktionalität
+ **Authentifizierung**: Es akzeptiert die Parameter Benutzername (`usr`) und Passwort (`pwd`) aus der Anfrage und authentifiziert den Benutzer
  unter Verwendung einer Instanz von AuthService.
+ **Token-Generierung**: Nach erfolgreicher Authentifizierung wird ein Authentifizierungs-Token mithilfe der AuthToken-Klasse erzeugt und
  und gibt es als JSON-Antwort zurück.
+ **Route**: Die Aktionsmethode wird auf die `/ldaps`-Route abgebildet.


## AuthService

### Übersicht
Die Klasse `AuthService` bietet Funktionen zur Authentifizierung von Benutzern gegenüber einem LDAP-Server.

### Code Auszug
```php
class AuthService
{
  public function authenticateUser($user, $password): bool
  {
    $success = null;
    try {
      $ds = ldap_connect($_ENV["LDAP_URL"]) or throw new Exception("Could not connect to LDAP server.");
      if ($ds) {
        // LDAP-Request for Test-Environment
        $userDN = "cn=$user,ou=TestUsers," . $_ENV["LDAP_BASE"];

        // Attempt to bind to the LDAP server with user credentials
        $success = @ldap_bind($ds, $userDN, $password) or throw new Exception("Error trying to bind: " . ldap_error($ds));

        ldap_close($ds);
      }
    } catch (Exception $e) {
      $success = false;
    }
    return $success;
  }
}
```

### Funktionalität
+ **LDAP-Verbindung**: Er stellt eine Verbindung zu dem in der Umgebungsvariablen `LDAP_URL` angegebenen LDAP-Server her.
+ **Authentifizierung**: Es wird versucht, sich mit den angegebenen Benutzerdaten ($user und $password) innerhalb der angegebenen LDAP-Basis an den LDAP-Server zu binden.
+ **Fehlerbehandlung**: Es fängt alle Ausnahmen ab, die während des Authentifizierungsprozesses auftreten, und gibt im Falle eines Fehlers `false` zurück.


## AuthToken

### Übersicht
Die Klasse `AuthentToken` ist für die Kodierung und Dekodierung von JSON-Web-Tokens (JWTs) unter Verwendung eines angegebenen Schlüssels zuständig.

### Code Auszug
```php
class AuthToken
{
  private string $key;
  public string $jwtString;
  public bool $success;

  // ...

  private function encode(array $data): string // [!code highlight]
  {
    try {
      $data = array_merge($data, ['iat' => (int)date('U')]);
      return JWT::encode($data, $this->key);
    } catch (Exception $e) {
      throw new JWTEncodeFailureException(JWTEncodeFailureException::INVALID_CONFIG, 'An error occurred while trying to encode the JWT token.', $e);
    }
  }

  public function decode($token): array // [!code highlight]
  {
    try {
      return (array)JWT::decode($token, $this->key);
    } catch (Exception $e) {
      throw new JWTDecodeFailureException(JWTDecodeFailureException::INVALID_TOKEN, 'Invalid JWT Token', $e);
    }
  }

  // ...
}
```

### Funktionalitäten
+ **Token-Kodierung**: Es kodiert eine Nutzlast in ein JWT unter Verwendung des angegebenen Schlüssels.
+ **Token-Dekodierung**: Dekodiert ein JWT-Token unter Verwendung des angegebenen Schlüssels.
+ **Ausnahmebehandlung**: Es fängt Ausnahmen während der Kodierungs- und Dekodierungsprozesse ab und löst entsprechende Ausnahmen aus.

