import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TemplateOption extends StatelessWidget {
  const TemplateOption({
    super.key,
    required this.title,
    this.onTap,
    required this.icon,
  });
  final String title;
  final VoidCallback? onTap;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 50.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 20.w,
            ),
            Container(
              width: 200.w,
              height: 40.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 7,
                      spreadRadius: 1,
                    ),
                  ]),
              child: Center(
                  child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              )),
            )
          ],
        ),
      ),
    );
  }
}
