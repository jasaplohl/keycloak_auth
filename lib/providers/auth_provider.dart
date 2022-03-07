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
      if(value != null) {
        isLoggedIn = true;
        idToken = value.idToken;
        parseIdTokenDecode(idToken!);
        notifyListeners();
      }
    })
    .catchError((error) {
      print("Error:");
      print(error);
      isLoggedIn = false;
      idToken = null;
      notifyListeners();
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
    .then((value) {
      isLoggedIn = false;
      notifyListeners();
    })
    .catchError((error) {
      print("Log out failed!");
      print(error);
    });
  }

  void parseIdTokenDecode(String idToken) {
    final List<String> parts = idToken.split('.');
    final Map parsed = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    parsed.keys.forEach((element) {
      print("$element => ${parsed[element]}");
    });
  }

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    Uri url = Uri(path: Environment.userInfoEndpoint);
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }
  
}