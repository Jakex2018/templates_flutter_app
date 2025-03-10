import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:templates_flutter_app/screens/auth/login/login_screen.dart';
import 'package:templates_flutter_app/screens/auth/model/user_model.dart';

Future<void> registerUser(String username, String email, String password,
    BuildContext context) async {
  try {
    final UserCredential registerCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    if (registerCredential.user == null) {
      Fluttertoast.showToast(
        msg: "No User Register",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, // 1 second for iOS/Web
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    if (registerCredential.user != null) {
      final User? user = registerCredential.user;
      final userId = user?.uid;
      final emailUser = user?.email ?? 'No email';
      final userModel =
          UserModel(username: username, isSubscribed: false, email: emailUser,id: userId!);

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userDoc.set(userModel.toMap(), SetOptions(merge: true));
      await registerCredential.user?.sendEmailVerification();
      await registerCredential.user?.updateDisplayName(username);
      Fluttertoast.showToast(
        msg:
            "Registration Successfull!\nCheck your email and verify your account",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, // 1 second for iOS/Web
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ));
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
    } else if (e.code == 'wrong-password') {
    } else {}
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(bottom: 50, left: 60, right: 50),
        content: Text(e.code),
      ),
    );
  }
}