import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './pages/home_page.dart';
import './pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: const MyAppBody(),
        routes: {
          HomePage.routeName: (context) => const HomePage()
        },
      )
    );
  }
}

class MyAppBody extends StatelessWidget{
  const MyAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isLoggedIn
      ? const HomePage()
      : const LoginPage();
  }
}