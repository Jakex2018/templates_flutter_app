import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/controllers/auth_controller.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/widget/login_with.dart';
import 'package:templates_flutter_app/widget/register_tercerd.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameField = TextEditingController();
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  String username = '';
  String email = '';
  String password = '';
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    final AuthController registerController = AuthController();
    return Material(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            child: const Icon(Icons.arrow_back_rounded)),
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .8,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameField,
                    decoration: InputDecoration(
                      labelText: 'Enter your username',
                      errorText: usernameField.text.isEmpty
                          ? 'Please enter a valid username'
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
                  const SizedBox(
                    height: 25,
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
                  const SizedBox(
                    height: 25,
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
                      if (_formKey.currentState!.validate()) {
                        String username = usernameField.text;
                        String email = emailField.text;
                        String password = passwordField.text;
                        await registerController.registerUser(
                            username, email, password, context, _formKey);
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.only(
                                bottom: 50, left: 60, right: 50),
                            content: Text('Input required values'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ),
                  const LoginWith(),
                  const RegisterTercerd(),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
