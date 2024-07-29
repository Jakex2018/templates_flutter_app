import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/register/widget/register_tercerd.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  bool isLoggedIn = false;
  String email = '';
  String password = '';
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 40.h, left: 30.w),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              width: MediaQuery.of(context).size.width,
              child: Form(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailField,
                        decoration: InputDecoration(
                          labelText: 'Enter your email',
                          errorText: emailField.text.isEmpty ||
                                  !emailField.text.contains('@') ||
                                  !emailField.text.contains('.')
                              ? 'Please enter a valid email'
                              : null,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 20.w),
                          labelStyle: const TextStyle(color: Colors.black26),
                          fillColor: const Color(0xFFF3F3F3),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: aDefaultPadding.h,
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 20.w),
                          labelStyle: const TextStyle(color: Colors.black26),
                          fillColor: const Color(0xFFF3F3F3),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.sp),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          return null;
                        },
                        onSaved: (value) => password = value!,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String emailData = emailField.text;
                          String passwordData = passwordField.text;
                          try {
                            await loginUser(
                                context, emailData, passwordData, isLoggedIn);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ));
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: "Login Failed: $e",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1, // 1 second for iOS/Web
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: const Text('Iniciar sesión'),
                      ),
                      const LoginWith(),
                      const RegisterTercerd(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> loginUser(BuildContext context, String email, String password,
      bool isLoggedIn) async {
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
      }

      if (loginCredential.user != null) {
        setState(() {
          isLoggedIn = true;
        });

        Fluttertoast.showToast(
          msg: "Login Successfull!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1, // 1 second for iOS/Web
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
    }

    return false;
  }
}

class LoginWith extends StatelessWidget {
  const LoginWith({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 70.w,
            height: 1.5.h,
            color: Colors.black38,
          ),
          Text(
            'Or Signin with',
            style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: 70.w,
            height: 1.5.h,
            color: Colors.black38,
          )
        ],
      ),
    );
  }
}
