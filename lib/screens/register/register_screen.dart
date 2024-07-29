import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/register/widget/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 40.h, left: 20.w),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios),
                  SizedBox(width: 10.w,),
                  Text('Register',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),),
                ],
              ),
            ),
          ),
          const RegisterForm(),
        ],
      ),
    ));
  }
}

