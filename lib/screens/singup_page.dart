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
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  static final routeName = "SingUp";
  final Function toggleView;
  SignUpPage({this.toggleView});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String password;
  File _image;
  ImagePicker _picker = ImagePicker();

  User user = User();
  final _formStateSingUp = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _onSignUp() async {
    if (!_formStateSingUp.currentState.validate()) {
      return;
    }
    _formStateSingUp.currentState.save();
    setState(() {
      isLoading = true;
    });
    await AuthServise()
        .singUp(
      email: user.email,
      password: password,
    )
        .then((value) async {
      if (value != null) {
        await DataBaseService().postUser(user);
        var a = await DataBaseService().getCurrentUserData(user.id);
        HelperFunctions.saveLogged(true);
        HelperFunctions.saveUserCurrentId(a.id);
        HelperFunctions.saveUserName(a.name);
        HelperFunctions.saveUserEmail(a.email);
        Navigator.of(context).pushReplacementNamed(ChatRoom.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Container(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : _bodySingUp());
  }

  _imgFromCamera(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  _imgFromGallery(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 50);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _avatarImage() {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: CircleAvatar(
            radius: 60,
            backgroundColor: newColor4,
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      _image,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: newColor4,
                        borderRadius: BorderRadius.circular(55)),
                    width: 110,
                    height: 110,
                    child: Center(
                        child: Text(
                      "Upload Profile Image",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w100,
                          fontSize: 15),
                      textAlign: TextAlign.center,
                    )))),
      ),
    );
  }

  // Future uploadImageToFirebase(BuildContext context) async {
  //   String fileName = basename(_imageFile.path);
  //   var firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   var uploadTask = firebaseStorageRef.putFile(_imageFile);
  //   var taskSnapshot = await uploadTask.runtimeType
  //   taskSnapshot.ref.getDownloadURL().then(
  //         (value) => print("Done: $value"),
  //       );
  // }

  Widget _bodySingUp() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 50, left: 18, right: 18),
        child: Form(
          key: _formStateSingUp,
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Sing Up",
                      style: TextStyle(color: Colors.black, fontSize: 18))),
              _avatarImage(),
              Container(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 5),
                      ], borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: CustomInput(
                        color: Colors.white,
                        prefix: Icons.person_outline,
                        hintText: 'Name',
                        onSaved: (v) => user.name = v,
                        validator: (v) => v.isEmpty ? 'Name is Empty' : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 5),
                      ], borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: CustomInput(
                        color: Colors.white,
                        prefix: Icons.person_outline,
                        hintText: 'Sure Name',
                        onSaved: (v) => user.surname = v,
                        validator: (v) =>
                            v.isEmpty ? 'Sure Name is Empty' : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 5),
                      ], borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: CustomInput(
                        color: Colors.white,
                        prefix: Icons.email_outlined,
                        hintText: 'Email',
                        onSaved: (v) => user.email = v,
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
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 5),
                      ], borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: CustomInput(
                        color: Colors.white,
                        prefix: Icons.lock_outline,
                        hintText: 'Password',
                        onSaved: (v) => this.password = v,
                        validator: (v) =>
                            v.isEmpty ? "Password is required" : null,
                        obscureText: true,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 5),
                      ], borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: CustomInput(
                        color: Colors.white,
                        prefix: Icons.lock_outline,
                        hintText: 'Reapit Password',
                        onSaved: (v) => this.password = v,
                        validator: (v) =>
                            v.isEmpty ? "Password is required" : null,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),
              CustumButton(
                text: "Sign Up",
                onTap: _onSignUp,
              ),
              Container(
                child: CustumButton(
                    text: "Go to Sing In", onTap: widget.toggleView),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
