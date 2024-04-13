import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/login/widget/form_data.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...formFields.map((formData) => _buildFormField(formData)),
          Padding(
            padding: EdgeInsets.only(left: 165.w),
            child: Text(
              'Forgot Password',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black26,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ButtonOne(text: 'Login', onPressed: (){}),
        ],
      ),
    ));
  }

  Widget _buildFormField(FormData formData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formData.label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        formData.input,
        SizedBox(height: 20.h),
      ],
    );
  }
}


