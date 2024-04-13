import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:gif_view/gif_view.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground(
      {super.key,
      this.title,
      this.desc,
      this.icon,
      this.left,
      this.top,
      required this.onPressed, required this.sidebarIcon});
  final String? title, desc;
  final Icon? icon;
  final double? left, top;
  final VoidCallback onPressed;
  final IconData sidebarIcon;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GifView(
        height: MediaQuery.of(context).size.height * .5,
        image: const AssetImage('asset/bg_01_animate.gif'),
        fit: BoxFit.fitHeight,
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kblueColor.withOpacity(.73),
      ),
      Positioned(
        top: 50,
        left: 10,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  desc ?? "",
                  style: TextStyle(
                      color: kLightText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.only(left: 10.w, bottom: 53.h),
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    sidebarIcon,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ))
          ],
        ),
      ),
    ]);
  }
}