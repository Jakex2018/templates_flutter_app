import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
import 'package:templates_flutter_app/screens/home/widget/home_type_content.dart';

class About extends StatelessWidget {
  const About({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          HomeBackground(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            title: 'Hello,Armando!!',
            desc: 'It s time for build your dream\napplication',
            sidebarIcon: Icons.menu,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: 470.h,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              )),
          Positioned(
            top: 210.h,
            left: 0.w,
            child: const HomeTypeContent(
              title: 'About',
            ),
          )
        ],
      ),
    );
  }
}
