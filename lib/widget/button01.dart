// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';

class ButtonOne extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final double margin;

  const ButtonOne({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = kpurpleColor,
    this.textColor = Colors.white,
    required this.width,
    required this.height,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin.h),
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          textStyle: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold), // Adjust font size as needed
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.sp), // Customize button shape
          ),
        ),
      ),
    );
  }
}
