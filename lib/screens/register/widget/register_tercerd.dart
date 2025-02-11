import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';

class RegisterTercerd extends StatefulWidget {
  const RegisterTercerd({
    super.key,
  });

  @override
  State<RegisterTercerd> createState() => _RegisterTercerdState();
}

class _RegisterTercerdState extends State<RegisterTercerd> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
   
    final GoogleSignIn googleSignIn = GoogleSignIn();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/login_01.png',
            color: Theme.of(context).colorScheme.inversePrimary,
            height: 50.h,
          ),
          SizedBox(
            width: aDefaultPadding.w,
          ),
          GestureDetector(
            onTap: () async {
              await _signInGoogle(googleSignIn, authProvider);
              // ignore: use_build_context_synchronously
              navigateHome(context);
            },
            child: Image.asset(
              'asset/login_02.png',
              height: 50.h,
            ),
          ),
        ],
      ),
    );
  }

  void navigateHome(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ));
  }

  Future<void> _signInGoogle(
      googleSignIn, AuthUserProvider authProvider) async {
       
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
      await FirebaseAuth.instance.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

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
            username: user.displayName, isSubscribed: false, email: email, id: userId);

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
        authProvider.setLoggedIn(true);
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
    }
  }
}
