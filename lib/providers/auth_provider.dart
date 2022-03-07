import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import '../env.dart';

class AuthProvider with ChangeNotifier {
  final FlutterAppAuth appAuth = FlutterAppAuth();

  final AuthorizationServiceConfiguration config = const AuthorizationServiceConfiguration(
    authorizationEndpoint: Environment.authorizationEndpoint,
    tokenEndpoint: Environment.tokenEndpoint,
    endSessionEndpoint: Environment.endSessionEndpoint
  );

  String? idToken;
  bool isLoggedIn = false;
  String? name;

  void login() async {
    final AuthorizationTokenRequest request = AuthorizationTokenRequest(
      Environment.clientId,
      Environment.redirectUri,
      issuer: Environment.issuer,
      scopes: Environment.scopes,
      discoveryUrl: Environment.discoveryUrl,
      serviceConfiguration: config,
      allowInsecureConnections: Environment.allowInsecureConnections
    );

    appAuth.authorizeAndExchangeCode(request)
    .then((value) {
      isLoggedIn = true;
      idToken = value!.idToken;
    })
    .catchError((error) {
      debugPrint(error);
      isLoggedIn = false;
      idToken = null;
    })
    .then((_) => {
      notifyListeners()
    });
  }

  void logout() async {
    appAuth.endSession(EndSessionRequest(
      idTokenHint: idToken,
      issuer: Environment.issuer,
      postLogoutRedirectUrl: Environment.redirectUri,
      allowInsecureConnections: Environment.allowInsecureConnections,
      serviceConfiguration: config
    ))
    .then((_) {
      isLoggedIn = false;
      notifyListeners();
    })
    .catchError((error) {
      debugPrint(error);
    });
  }

  Map<String, String> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    final Map<String, String> parsed = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    return parsed;
  }

  void getUserDetails(String accessToken) async {
    Uri url = Uri.parse(Environment.userInfoEndpoint);
    http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken'
      },
    )
    .then((response) {
      parseUserdetails(response);
    })
    .catchError((erorr) {
      print(erorr);
    });
  }

  void parseUserdetails(http.Response response) {
    Map<String, dynamic> details = jsonDecode(response.body);
    if(response.statusCode == 200) {

    } else {
      print("Failed to get user details!");
    }
  }
  
}