import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HomePage extends StatefulWidget {

  static const routeName = "/home";

  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final AuthProvider ordersProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: TextButton(
                onPressed:  ordersProvider.logout, 
                child: const Text("Log out")
              )
            ),
          )
        ],
      )
    );
  }

}