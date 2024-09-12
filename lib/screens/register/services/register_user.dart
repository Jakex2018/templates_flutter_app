import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';

Future<void> registerUser(String username, String email, String password,
    BuildContext context) async {
  try {
    final registerCredential = await FirebaseAuth.instance
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

    final userModel =
        UserModel(username: username, isSubscribed: false, email: email);
    final userDoc = FirebaseFirestore.instance.collection('users').doc();
    await userDoc.set(userModel.toMap(), SetOptions(merge: true));
    if (registerCredential.user != null) {
      await registerCredential.user?.sendEmailVerification();
      await registerCredential.user?.updateDisplayName(username);
      Fluttertoast.showToast(
        msg: "Registration Successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, // 1 second for iOS/Web
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/home');
    }
  } catch (e) {
    throw Exception('Registration failed due to network error');
  }
}
