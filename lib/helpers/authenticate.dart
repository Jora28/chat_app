import 'package:chat_app/screens/signin_page.dart';
import 'package:chat_app/screens/singup_page.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  static final routeName = "Authenticate";

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SingInPage(toggleView: toggleView);
    } else {
      return SignUpPage(toggleView: toggleView);
    }
  }
}
