import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:keycloak_auth/env.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlutterAppAuth appAuth = FlutterAppAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentication")),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: loginRedirect, 
            child: const Text("Redirect to keycloak")
          ),
          TextButton(
            onPressed: logout, 
            child: const Text("Log out")
          )
        ],
      )
    );
  }

  void loginRedirect() async {

    try {

      const AuthorizationServiceConfiguration config = AuthorizationServiceConfiguration(
        authorizationEndpoint: Environment.authorizationEndpoint,
        tokenEndpoint: Environment.tokenEndpoint,
        endSessionEndpoint: Environment.endSessionEndpoint
      );

      final AuthorizationTokenRequest request = AuthorizationTokenRequest(
        Environment.clientId,
        Environment.redirectUri,
        issuer: Environment.issuer,
        scopes: Environment.scopes,
        discoveryUrl: Environment.discoveryUrl,
        serviceConfiguration: config,
        allowInsecureConnections: true
      );

      appAuth.authorizeAndExchangeCode(request)
      .then((value) => {
        print("Done:"),
        print(value)
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
}