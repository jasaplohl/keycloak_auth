import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text("Authentication")),
        body: Column(
          children: [
            TextButton(
              onPressed: loginRedirect, 
              child: const Text("Redirect to keycloak")
            ),
            TextButton(
              onPressed: loginWithAPI, 
              child: const Text("Log in with keycloak")
            )
          ],
        )
      ),
    );
  }

  void loginRedirect() async {
    final FlutterAppAuth appAuth = FlutterAppAuth();

    try {
      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          "flutter-client",
          "com.authapp://login-callback",
          issuer: 'http://10.0.2.2:8080/realms/flutter-app',
          scopes: ['openid'],
          // clientSecret: "1bfHS44WmDTpsmllx53v1My9jnGjAlT5",
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/auth",
            tokenEndpoint: "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/token",
            endSessionEndpoint: "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/logout"
          ),
        ),
      );

      if(result != null) {
        print(result);
      }
    } catch(error) {
      print(error);
    }
  }

  void loginWithAPI() async {
    var url = Uri.parse('http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/token');
    var response = await http.post(
      url, 
      body: {
        'client_id': 'flutter-client', 
        'grant_type': 'password',
        'username': 'jasa',
        'password': 'jasa',
        'scope': 'openid',
        'client_secret': '1bfHS44WmDTpsmllx53v1My9jnGjAlT5'
      }
    );
    final Map parsed = json.decode(response.body);
    parsed.keys.forEach((key) {
      print("$key => ${parsed[key]}");
    });

    print('Response status: ${response.statusCode}');
  }
}