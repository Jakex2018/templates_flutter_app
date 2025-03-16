import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:templates_flutter_app/controllers/auth_controller.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/widget/login_with.dart';
import 'package:templates_flutter_app/widget/register_tercerd.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final AuthController loginController = AuthController();
    final formKey = GlobalKey<FormState>();
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            child: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .8,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
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
                            ? 'Please enter your password (min 8 characters)'
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
                      height: 30.h,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String emailData = emailField.text;
                        String passwordData = passwordField.text;

                        // Llamar al controlador en lugar del servicio
                        await loginController.loginUser(
                            emailData, passwordData, context, formKey);
                      },
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
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
      ),
    );
  }
}
