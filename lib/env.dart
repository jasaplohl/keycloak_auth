class Environment {

  // LOCALHOST VARIABLES

  // static const realmId = "flutter-app";
  static const realmId = "theme_test";
  static const clientId = 'flutter-client';
  static const host = "http://10.0.2.2:8080";

  static const redirectUri = 'com.authapp://login-callback/';

  static const clientSecret = "GpDYXJKabQz31xHHEzaBaoeCOmIACR5e";
  static const discoveryUrl = "$host/realms/$realmId/.well-known/openid-configuration";
  static const issuer = '$host/realms/$realmId';
  static const authorizationEndpoint = "$host/realms/$realmId/protocol/openid-connect/auth";
  static const tokenEndpoint = "$host/realms/$realmId/protocol/openid-connect/token";
  static const endSessionEndpoint = "$host/realms/$realmId/protocol/openid-connect/logout";
  static const userInfoEndpoint = "$host/realms/$realmId/protocol/openid-connect/userinfo";
  static const introspectEndpoint = "$host/realms/$realmId/protocol/openid-connect/token/introspect";
  static const List<String> scopes = ["openid", "offline_access", "profile"];
  static const bool allowInsecureConnections = true;

  // static const clientId = 'flutter-client';
  // static const clientSecret = "EPJsmMhYlkq1SIgIAw71W2PjZr3WFKgP";
  // static const discoveryUrl = "https://keycloak.devleet.si/auth/realms/flutter-app/.well-known/openid-configuration";

  // static const redirectUri = 'com.authapp://login-callback/';
  // static const issuer = 'https://keycloak.devleet.si/auth/realms/flutter-app';

  // static const authorizationEndpoint = "https://keycloak.devleet.si/auth/realms/flutter-app/protocol/openid-connect/auth";
  // static const tokenEndpoint = "https://keycloak.devleet.si/auth/realms/flutter-app/protocol/openid-connect/token";
  // static const endSessionEndpoint = "https://keycloak.devleet.si/auth/realms/flutter-app/protocol/openid-connect/logout";
  // static const userInfoEndpoint = "https://keycloak.devleet.si/auth/realms/flutter-app/protocol/openid-connect/userinfo";

  // static const introspectEndpoint = "https://keycloak.devleet.si/auth/realms/flutter-app/protocol/openid-connect/token/introspect";

  // static const List<String> scopes = ["openid", "offline_access", "profile"];

  // static const bool allowInsecureConnections = true;

}