import 'dart:io';

import 'package:chat_app/helpers/helpers.dart';
import 'package:chat_app/helpers/utils.dart';
import 'package:chat_app/moodels/user.dart';
import 'package:chat_app/screens/conversation_page.dart';

import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_servise.dart';
import 'package:chat_app/widgets/buttons.dart';
import 'package:chat_app/widgets/inpurs.dart';
import 'package:chat_app/widgets/style_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingInPage extends StatefulWidget {
  static final routeName = "SingIn";
  final Function toggleView;
  SingInPage({this.toggleView});

  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  String password;
  User user = User();
 

  final _formStateSingIn = GlobalKey<FormState>();
  bool isLoading = false;

  void _onSignIn() async {
    if (!_formStateSingIn.currentState.validate()) {
      return;
    }
    _formStateSingIn.currentState.save();

    setState(() {
      isLoading = true;
    });

    await AuthServise()
        .singIn(email: user.email, password: password)
        .then((value) async {
      if (value) {
        var a = await DataBaseService().getCurrentUserData(user.id);
        HelperFunctions.saveLogged(true);
        HelperFunctions.saveUserCurrentId(a.id);
        HelperFunctions.saveUserName(a.name+" "+a.surname);
        HelperFunctions.saveUserEmail(a.email);
        Navigator.of(context).pushReplacementNamed(ChatRoom.routeName);
      } else {
        showToast(message: "Please Write a Falid Email or Password");
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(backgroundColor: Colors.white, body: _bodySingIn()),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
  Widget _bodySingIn() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 100, left: 18, right: 18),
        child: Form(
          key: _formStateSingIn,
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Sing In",
                      style: TextStyle(color: Colors.black, fontSize: 18))),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 1), blurRadius: 5),
                ], borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: CustomInput(
                  color: Colors.white,
                  prefix: Icons.person_outline,
                  hintText: "Email",
                  onSaved: (v) => this.user.email = v,
                  validator: (v) => v.isEmpty
                      ? "Email is required!"
                      : isValidEmail(v)
                          ? null
                          : "Invalid email",
                ),
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 1), blurRadius: 5),
                ], borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: CustomInput(
                  color: Colors.white,
                  prefix: Icons.lock_outline,
                  hintText: "Password",
                  onSaved: (v) => this.password = v,
                  validator: (v) => v.isEmpty ? "Password is required" : null,
                  obscureText: true,
                ),
              ),
              Container(
                child: CustumButton(
                  text: "Sign In",
                  onTap: _onSignIn,
                ),
              ),
              Container(
                child: CustumButton(
                    text: "Go to Sing Up", onTap: widget.toggleView),
              )
            ],
          ),
        ),
      ),
    );
  }
}
