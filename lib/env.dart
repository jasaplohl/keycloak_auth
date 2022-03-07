class Environment {
  static const clientId = 'flutter-client';
  static const discoveryUrl = "http://10.0.2.2:8080/realms/flutter-app/.well-known/openid-configuration";

  static const redirectUri = 'com.authapp://login-callback/';
  static const issuer = 'https://10.0.2.2:8080/realms/flutter-app';

  static const authorizationEndpoint = "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/auth";
  static const tokenEndpoint = "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/token";
  static const endSessionEndpoint = "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/logout";
  static const userInfoEndpoint = "http://localhost:8080/realms/flutter-app/protocol/openid-connect/userinfo";

  static const List<String> scopes = ["openid"];

  static const bool allowInsecureConnections = true;
}