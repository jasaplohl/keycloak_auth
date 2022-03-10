import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../env.dart';

class AuthProvider with ChangeNotifier {
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final AuthorizationServiceConfiguration config = const AuthorizationServiceConfiguration(
    authorizationEndpoint: Environment.authorizationEndpoint,
    tokenEndpoint: Environment.tokenEndpoint,
    endSessionEndpoint: Environment.endSessionEndpoint
  );

  DateTime? expirationDate;
  String? accessToken;
  String? idToken;
  bool isLoggedIn = false;

  AuthProvider() {
    initAuth();
  }

  Future<void> initAuth() async {
    final String? storedRefreshToken = await secureStorage.read(key: "refresh_token");

    if(storedRefreshToken == null) return;
    
    getAccessToken(storedRefreshToken);
  }

  void getAccessToken(String refreshToken) async {
    await appAuth.token(TokenRequest(
      Environment.clientId, 
      Environment.redirectUri,
      issuer: Environment.issuer,
      allowInsecureConnections: Environment.allowInsecureConnections,
      serviceConfiguration: config,
      clientSecret: Environment.clientSecret,
      refreshToken: refreshToken
    ))
    .then((value) async {
      isLoggedIn = true;
      idToken = value!.idToken;
      accessToken = value.accessToken;
      expirationDate = value.accessTokenExpirationDateTime;
      await secureStorage.write(key: "refresh_token", value: value.refreshToken);
    })
    .catchError((error) async {
      print(error);
      await secureStorage.delete(key: 'refresh_token');
    })
    .then((value) => {
      notifyListeners()
    });
  }

  void login() async {
    final AuthorizationTokenRequest request = AuthorizationTokenRequest(
      Environment.clientId,
      Environment.redirectUri,
      issuer: Environment.issuer,
      scopes: Environment.scopes,
      discoveryUrl: Environment.discoveryUrl,
      serviceConfiguration: config,
      allowInsecureConnections: Environment.allowInsecureConnections,
      clientSecret: Environment.clientSecret
    );

    appAuth.authorizeAndExchangeCode(request)
      .then((value) async {
        isLoggedIn = true;
        idToken = value!.idToken;
        accessToken = value.accessToken;
        expirationDate = value.accessTokenExpirationDateTime;
        await secureStorage.write(key: "refresh_token", value: value.refreshToken);
      })
      .catchError((error) async {
        print(error);
        isLoggedIn = false;
        idToken = null;
        await secureStorage.delete(key: 'refresh_token');
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
      .then((_) async {
        isLoggedIn = false;
        await secureStorage.delete(key: 'refresh_token');
        notifyListeners();
      })
      .catchError((error) {
        print(error);
      });
  }

  void introspectToken() async {
    Uri url = Uri.parse(Environment.introspectEndpoint);
    http.post(
      url,
      body: {
        "token": accessToken,
        "client_id": Environment.clientId,
        "client_secret": Environment.clientSecret
      }
    )
      .then((response) {
        print(response.body);
      })
      .catchError((error) {
        print(error);
      });
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    Uri url = Uri.parse(Environment.userInfoEndpoint);
    Map<String, dynamic> details = {};
    try {
      http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken'
        },
      );
      if(response.statusCode == 200) {
        details = jsonDecode(response.body);
      } else {
        throw Exception("Failed to get user details!");
      }
    } catch(error) {
      print(error);
    }
    return details;
  }
  
}