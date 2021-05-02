import 'package:chat_app/moodels/user.dart' as userModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServise {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store;

  Future<bool> singUp({String email, String password}) async {
    try {
      var res = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return res.user != null;
    } catch (e) {
      e.toString();
      return false;
    }
  }

  Future<bool> singIn({String email, String password}) async {
    try {
      var res = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return res.user != null;
    } catch (e) {
      e.toString();
      return false;
    }
  }

    Future logout() async {
    await auth.signOut();
  }

  Future resetPassword({String email}) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
}
