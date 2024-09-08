import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/register/widget/register_tercerd.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final usernameField = TextEditingController();
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * .9,
        child: Form(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: usernameField,
                decoration: InputDecoration(
                  labelText: 'Enter your username',
                  errorText: usernameField.text.isEmpty
                      ? 'Please Enter your Username'
                      : null,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.h, horizontal: 20.w),
                  labelStyle: const TextStyle(color: Colors.black26),
                  fillColor: const Color(0xFFF3F3F3),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                ),
              ),
              TextFormField(
                controller: emailField,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  errorText: emailField.text.isEmpty ||
                          !emailField.text.contains('@') ||
                          !emailField.text.contains('.')
                      ? 'Please enter a valid email'
                      : null,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
                  labelStyle: const TextStyle(color: Colors.black26),
                  fillColor: const Color(0xFFF3F3F3),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                ),
              ),
              TextFormField(
                controller: passwordField,
                obscureText: obscureText,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                  labelText: 'Enter your Password',
                  errorText: passwordField.text.isEmpty ||
                          passwordField.text.length < 8
                      ? 'Please enter your passord max 8 caracter'
                      : null,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
                  labelStyle: const TextStyle(color: Colors.black26),
                  fillColor: const Color(0xFFF3F3F3),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                ),
              ),
              const RegisterFormForgot(),
              SizedBox(
                height: 10.h,
              ),
              const RegisterTercerd(),
              SizedBox(
                height: 2.h,
              ),
              ButtonOne(
                text: 'Register',
                onPressed: () async {
                  String username = usernameField.text;
                  String email = emailField.text;
                  String password = passwordField.text;

                  try {
                    await registerUser(username, email, password);
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
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Registration Failed: $e",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1, // 1 second for iOS/Web
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                backgroundColor: kpurpleColor,
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class RegisterFormForgot extends StatelessWidget {
  const RegisterFormForgot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 165.w),
      child: Text(
        'Forgot Password',
        style: TextStyle(
            fontSize: 13.sp,
            color: Colors.black26,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

Future<void> registerUser(
    String username, String email, String password) async {
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
    final user = registerCredential.user;
    final userDoc = FirebaseFirestore.instance.collection('users');
    await userDoc
        .doc(user!.uid)
        .set({'username': username, 'email': email, 'password': password});
    if (registerCredential.user != null) {
      await registerCredential.user?.sendEmailVerification();
      await registerCredential.user?.updateDisplayName(username);
      Fluttertoast.showToast(
        msg: "'An email has been sent to your registered email'",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, // 1 second for iOS/Web
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    throw Exception('Registration failed due to network error');
  }
}
