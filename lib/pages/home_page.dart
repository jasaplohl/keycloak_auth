import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

// import './web_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterAppAuth appAuth = FlutterAppAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentication")),
      body: Column(
        children: <Widget>[
          // TextButton(
          //   onPressed: () => loginWebview(), 
          //   child: const Text("Webview")
          // ),
          TextButton(
            onPressed: loginRedirect, 
            child: const Text("Redirect to keycloak")
          ),
          TextButton(
            onPressed: logout, 
            child: const Text("Log out")
          ),
          // TextButton(
          //   onPressed: loginWithAPI, 
          //   child: const Text("Log in with API")
          // )
        ],
      )
    );
  }

  void loginRedirect() async {

    try {

      AuthorizationTokenRequest request = AuthorizationTokenRequest(
        "flutter-client",
        "com.authapp://login-callback/",
        issuer: 'https://10.0.2.2:8080/realms/flutter-app',
        scopes: ['openid'],
        discoveryUrl: "http://10.0.2.2:8080/realms/flutter-app/.well-known/openid-configuration",
        serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint: "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/auth",
          tokenEndpoint: "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/token",
          endSessionEndpoint: "http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/logout"
        ),
        allowInsecureConnections: true
      );

      appAuth.authorizeAndExchangeCode(request)
      .then((value) => {
        print("Done:"),
        print(value!.accessToken)
      })
      .catchError((error) => {
        print("Error:"),
        print(error)
      });
    } catch(error) {
      print("Another Error:");
      print(error);
    }
  }

  void logout() async {
    try {
      await appAuth.endSession(EndSessionRequest(

      ));
    } catch(error) {
      print(error);
    }
  }

  // UNSAFE: Because we have access to the users login details (username and password).
  void loginWithAPI() async {
    var url = Uri.parse('http://10.0.2.2:8080/realms/flutter-app/protocol/openid-connect/token');
    var response = await http.post(
      url, 
      body: {
        'client_id': 'flutter-client', 
        'grant_type': 'password',
        'username': 'jasa',
        'password': 'jasaa',
        'scope': 'openid',
      }
    );
    final Map parsed = json.decode(response.body);
    parsed.keys.forEach((key) {
      print("$key => ${parsed[key]}");
    });

    print('Response status: ${response.statusCode}');
  }

}