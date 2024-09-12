import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';

class LoginServices {
  Future<bool> loginUser(
      String email, String password, BuildContext context, formKey) async {
    if (formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthUserProvider>(context);
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        authProvider.setLoggedIn(true);

        //SAVE USER

        Fluttertoast.showToast(
          msg: "Login Successfull!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1, // 1 second for iOS/Web
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'La dirección de correo electrónico no está registrada.';
        } else if (e.code == 'wrong-password') {
          message = 'La contraseña es incorrecta.';
        } else {
          message = 'Ocurrió un error durante el inicio de sesión.';
        }
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1, // 1 second for iOS/Web
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
    return false;
  }
}



/*
class LoginServices {
  Future<bool> loginUser(
      String email, String password, BuildContext context, formKey) async {
    if (formKey.currentState!.validate()) {
      try {
        final loginCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (loginCredential.user == null) {
          Fluttertoast.showToast(
            msg: "No User Login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1, // 1 second for iOS/Web
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false;
        }

        if (loginCredential.user != null) {
          Fluttertoast.showToast(
            msg: "Login Successfull!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1, // 1 second for iOS/Web
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'La dirección de correo electrónico no está registrada.';
        } else if (e.code == 'wrong-password') {
          message = 'La contraseña es incorrecta.';
        } else {
          message = 'Ocurrió un error durante el inicio de sesión.';
        }
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1, // 1 second for iOS/Web
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return false;
      }
    }
  }
}

 */