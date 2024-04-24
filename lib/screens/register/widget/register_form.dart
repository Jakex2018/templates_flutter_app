import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/login/widget/form_data.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...formRegisterFields.map((formData) => _buildFormField(formData)),
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
          ButtonOne(
            text: 'Register',
            onPressed: () {},
            width: .5,
            height: -.3,
            margin: 20,
          ),
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
