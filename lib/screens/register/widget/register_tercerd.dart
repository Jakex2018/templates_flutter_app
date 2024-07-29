import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';

class RegisterTercerd extends StatefulWidget {
  const RegisterTercerd({
    super.key,
  });

  @override
  State<RegisterTercerd> createState() => _RegisterTercerdState();
}

class _RegisterTercerdState extends State<RegisterTercerd> {
  bool isLoggedIn = true;
  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/login_01.png',
            height: 50.h,
          ),
          SizedBox(
            width: aDefaultPadding.w,
          ),
          GestureDetector(
            onTap: () async {
              await _signInGoogle(googleSignIn);
              navigateHome();
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

  void navigateHome() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ));
  }

  Future<void> _signInGoogle(googleSignIn) async {
    await FirebaseAuth.instance.signOut();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        isLoggedIn = true;
      });
      Fluttertoast.showToast(
        msg: "Login Successfull!!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
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
