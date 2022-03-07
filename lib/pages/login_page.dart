import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final AuthProvider ordersProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Authentication")),
      body: isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: <Widget>[
              TextButton(
                onPressed: () => loginAction(ordersProvider), 
                child: const Text("Login with Keycloak")
              )
            ],
          )
    );
  }

  void loginAction(AuthProvider ordersProvider) {
    setState(() {
      isLoading = true;
    });
    ordersProvider.login();
    setState(() {
      isLoading = false;
    });
  }
}