import 'package:chat_app/helpers/authenticate.dart';
import 'package:chat_app/helpers/helpers.dart';
import 'package:chat_app/screens/chating_page.dart';
import 'package:chat_app/screens/conversation_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/search_page.dart';
import 'package:chat_app/screens/signin_page.dart';
import 'package:chat_app/screens/singup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
  
  getLoggedInState() async {
    await HelperFunctions.getLoggedIn().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? ChatRoom()
              : Authenticate()
          :  Authenticate(),
      routes: {
        ChatIngPage.routeName: (c) => ChatIngPage(),
        ChatRoom.routeName: (c) => ChatRoom(),
        ChatIngPage.routeName: (c) => ChatIngPage(),
        Authenticate.routeName: (c) => Authenticate(),
        SignUpPage.routeName: (c) => SignUpPage(),
        SingInPage.routeName: (c) => SingInPage(),
        HomePage.routeName: (c) => HomePage(),
        SearchPage.routeName:(c)=>SearchPage(),
      },
      title: 'Flutter Demo',
    );
  }
}
