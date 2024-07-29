


/*
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  String _username = '';
  String _password = '';
  final ZoomDrawerController controller = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese su nombre de usuario';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese su contraseña';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  String userData = _username;
                  String passwordData = _password;
                  await loginUser(userData, passwordData, _formKey);
                  setState(() {
                    isLoggedIn = true;
                  });
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Home(zoomDrawerController: controller),
                    ),
                  );
                },
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password, formKey) async {
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
    }
  }
}
 */


/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/login/services/login_services.dart';
import 'package:templates_flutter_app/screens/register/widget/register_form.dart';
import 'package:templates_flutter_app/screens/register/widget/register_tercerd.dart';
import 'package:templates_flutter_app/widget/button01.dart';

// ignore: must_be_immutable
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final LoginServices _dataService = LoginServices();
  final formKey = GlobalKey<FormState>();
  final emailField = TextEditingController();
  final passwordField = TextEditingController();

  bool isLoggedIn = false;
  bool obscureText = true;
  @override
  void dispose() {
    emailField.dispose();
    passwordField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * .9,
        child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const LoginWith(),
                  const RegisterTercerd(),
                  SizedBox(
                    height: 2.h,
                  ),
                  ButtonOne(
                    text: 'Login',
                    onPressed: () async {
                      String email = emailField.text;
                      String password = passwordField.text;
                      bool loginSuccess = await _dataService.loginUser(
                          email, password, context, formKey);
                      if (loginSuccess) {
                        setState(() {
                          isLoggedIn = true;
                        });

                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ),
                        );
                      }
                    },
                    width: MediaQuery.of(context).size.width,
                    height: 40.h,
                    margin: 8,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}



 */