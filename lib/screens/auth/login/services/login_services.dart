import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/auth/model/user_model.dart';

class LoginServices {
  Future<void> loginUser(
      String email, String password, BuildContext context, formKey) async {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      authProvider.setLoggedIn(true);

      //GET TOKEN FCM
      await FirebaseMessaging.instance.requestPermission();
      String? token = await FirebaseMessaging.instance.getToken();
     
      if (token != null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .set({'fcm_token': token}, SetOptions(merge: true));
        }
      }

      //SAVE USER
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
          content: Text('Login Successfull!!!'),
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ));
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'La dirección de correo electrónico no está registrada.';
      } else if (e.code == 'wrong-password') {
        message = 'La contraseña es incorrecta.';
      } else {
        message = 'Ocurrió un error durante el inicio de sesión.';
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.only(bottom: 50, left: 60, right: 50),
          content: Text(message),
        ),
      );
    }
  }
}
