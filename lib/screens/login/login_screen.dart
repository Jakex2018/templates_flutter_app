import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/services/login_services.dart';
import 'package:templates_flutter_app/screens/register/widget/register_tercerd.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailField = TextEditingController();
  final passwordField = TextEditingController();

  String email = '';
  String password = '';
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
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
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
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
                      String emailData = emailField.text;
                      String passwordData = passwordField.text;
                      try {
                        await LoginServices().loginUser(emailData, passwordData,
                            context, authProvider.isLogged);
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
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
                    child: Text(
                      'Iniciar sesión',
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
