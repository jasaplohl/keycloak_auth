class Environment {
  static const auth0Domain = 'http://localhost:8080/realms/flutter-app/protocol/openid-connect/auth';
  static const auth0ClientId = 'flutter-client';

  static const auth0RedirectUri = 'com.my_app.keycloak_auth://login-callback';
  static const auth0Issuer = 'http://localhost:8080/realms/flutter-app';
}