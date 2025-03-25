import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:templates_flutter_app/views/login_screen.dart';
import 'package:templates_flutter_app/models/user_model.dart';

class AuthServices {
  Future<void> loginUser(String email, String password, BuildContext context,
      formKey, AuthUserProvider authProvider) async {
    try {
      if (formKey.currentState!.validate()) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

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
        authProvider.setLoggedIn(true);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de Firestore: ${e.message}')),
      );
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

  Future<void> registerUser(String username, String email, String password,
      BuildContext context, GlobalKey<FormState> formKey) async {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    try {
      authProvider.setLoading(true);

      // 1. Validar formulario
      if (!formKey.currentState!.validate()) return;

      // 2. Crear usuario en Firebase Auth primero
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 3. Verificar que el usuario se creó correctamente
      if (userCredential.user == null) {
        throw Exception('User registration failed');
      }

      final User user = userCredential.user!;

      // 4. Crear el documento en Firestore con el UID como ID
      final userModel = UserModel(
        username: username,
        isSubscribed: false,
        email: email,
        id: user.uid,
      );

      // 5. Obtener token FCM
      String? token;
      try {
        await FirebaseMessaging.instance.requestPermission();
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        debugPrint('Error getting FCM token: $e');
      }

      // 6. Guardar usuario en Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        ...userModel.toMap(),
        'fcm_token': token,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 7. Actualizar display name
      await user.updateDisplayName(username);

      // 8. Mostrar éxito y redirigir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso!')),
      );

      authProvider.setLoggedIn(true);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'El correo ya está registrado';
          break;
        case 'weak-password':
          errorMessage = 'La contraseña es muy débil';
          break;
        default:
          errorMessage = 'Error de registro: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de Firestore: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: ${e.toString()}')),
      );
    } finally {
      authProvider.setLoading(false);
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      // Cerrar sesión con Firebase
      await FirebaseAuth.instance.signOut();

      // Limpiar estado de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn'); // Eliminar flag de sesión
      await prefs.remove('userId'); // Eliminar ID de usuario

      // Notificar a AuthUserProvider sobre el cambio de estado
      if (context.mounted) {
        final authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        await authProvider
            .setLoggedIn(false); // Actualizar el estado en el provider
      }

      // Redirigir a la pantalla de login
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      // Si ocurre algún error, mostrar un mensaje
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> signInGoogle(
      googleSignIn, AuthUserProvider authProvider, context) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: 'No internet connection.',
        toastLength: Toast.LENGTH_SHORT,
        // ... other toast configuration
      );
      return; // Prevent further execution if no internet
    }

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      authProvider.setLoggedIn(true);

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        final userId = user.uid;

        final email = user.email ?? 'No email';

        final userModel = UserModel(
            username: user.displayName,
            isSubscribed: false,
            email: email,
            id: userId);

        //GET TOKEN FCM

        await FirebaseMessaging.instance.requestPermission();
        String? token = await FirebaseMessaging.instance.getToken();

        if (token != null) {
          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(userId);

          await userDoc.set({...userModel.toMap(), 'fcm_token': token},
              SetOptions(merge: true));
        }

        ///SAVE USER
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);
        await userDoc.set(userModel.toMap(), SetOptions(merge: true));
      }
// ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
          content: Text("Login Successfull!!!"),
        ),
      );
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ));
    } on FirebaseAuthException {
      Fluttertoast.showToast(
        msg: 'Please connect Internet.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      authProvider.setLoading(false);
    }
  }
}
