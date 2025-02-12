import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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