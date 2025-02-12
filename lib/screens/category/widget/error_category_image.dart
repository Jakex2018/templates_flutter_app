import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';

class ErrorCategoryImage extends StatelessWidget {
  const ErrorCategoryImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: aDefaultPadding * 2,
          vertical: aDefaultPadding,
        ),
        child: Container(
          height: 210.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.sp),
              border: Border.all(color: Colors.black54, width: 2.sp)),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 54.sp),
              SizedBox(
                height: 5.sp,
              ),
              const Text(
                'Please, Connect your Internet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ));
  }
}