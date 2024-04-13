import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
class CategoryTypeContent extends StatelessWidget {
  const CategoryTypeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: kblueColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp))),
      child: Center(
          child: Text(
        'Restaurants',
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}

