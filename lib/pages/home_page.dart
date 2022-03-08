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

  String? email;
  String? username;
  String? name;
  bool? emailVerified;

  int _getDurationInSeconds(DateTime expirationDate) {
    int seconds = expirationDate.difference(DateTime.now()).inSeconds;
    return seconds;
  }

  String _getExpirationString(DateTime expirationDate) {
    int seconds = _getDurationInSeconds(expirationDate);
    if(seconds > 0) {
      return "Token valid for $seconds s";
    } else {
      return "Token expired ${seconds*-1} s ago";
    }
  }

  @override
  void didChangeDependencies() async {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    Map<String, dynamic> userDetails = await authProvider.getUserDetails();

    userDetails.keys.forEach((element) {
      print("$element => ${userDetails[element]}");
    });

    String? _email;
    String? _name;
    String? _username;
    bool? _emailVerified;

    if(userDetails.containsKey("email")) {
      _email = userDetails["email"];
    }

    if(userDetails.containsKey("name")) {
      _name = userDetails["name"];
    }

    if(userDetails.containsKey("preferred_username")) {
      _username = userDetails["preferred_username"];
    }

    if(userDetails.containsKey("email_verified")) {
      _emailVerified = userDetails["email_verified"];
    }

    setState(() {
      email = _email;
      name = _name;
      username = _username;
      emailVerified = _emailVerified;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_getExpirationString(authProvider.expirationDate!)),
          if(email != null) Text("Email: $email"),
          if(name != null) Text("Name: $name"),
          if(username != null) Text("Username: $username"),
          if(emailVerified != null) Text(emailVerified! ? "Email is verified." : "Email is not verified!"),
          TextButton(
            onPressed:  authProvider.logout, 
            child: const Text("Log out")
          )
        ],
      )
    );
  }

}