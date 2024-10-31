import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return const Text('dasdas');
  }
}

/*
return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 8,
        width: MediaQuery.of(context).size.width,
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameField,
                    decoration: InputDecoration(
                      labelText: 'Enter your username',
                      errorText: usernameField.text.isEmpty
                          ? 'Please Enter your Username'
                          : '',
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
                      if (_formKey.currentState!.validate()) {
                        String username = usernameField.text;
                        String email = emailField.text;
                        String password = passwordField.text;
                        await registerUser(username, email, password, context);
                      } else {
                        Fluttertoast.showToast(
                          msg: "Register Error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1, // 1 second for iOS/Web
                          backgroundColor: Colors.green,
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
 */

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
