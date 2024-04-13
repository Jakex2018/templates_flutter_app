import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/category/category_app.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Category(),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: aDefaultPadding / 2, vertical: aDefaultPadding),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                ),
              ]),
          child: Stack(children: [
            Image.asset(
              'asset/bg_01.jpg',
              height: 124.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 124.h,
                width: 148.w,
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(20.sp)),
                child: Center(
                  child: Text(
                    'Restaurants',
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}