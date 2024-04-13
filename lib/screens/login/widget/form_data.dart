import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormData {
  final String label;
  final Widget input;

  const FormData(this.label, this.input);
}

final List<FormData> formFields = [
  FormData(
    'Email Address',
    TextFormField(
      decoration: InputDecoration(
        labelText: 'Enter your email',
        contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
        labelStyle: const TextStyle(color: Colors.black26),
        fillColor: const Color(0xFFF3F3F3),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20.sp),
        ),
      ),
    ),
  ),
  FormData(
    'Password',
    TextFormField(
      decoration: InputDecoration(
        labelText: 'Enter your Password',
        contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
        labelStyle: const TextStyle(color: Colors.black26),
        fillColor: const Color(0xFFF3F3F3),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20.sp),
        ),
      ),
    ),
  ),
];
