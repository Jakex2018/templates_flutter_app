import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/login/widget/login_Background.dart';
import 'package:templates_flutter_app/screens/register/widget/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          LoginBackground(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            title: 'Flutter\nTemplates',
            sidebarIcon: Icons.menu,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: aDefaultPadding * 1.2,
                    horizontal: aDefaultPadding * 1.2),
                height: 560.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.sp),
                        topRight: Radius.circular(50.sp))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Please register your information',
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black26,
                          fontWeight: FontWeight.bold),
                    ),
                    const RegisterForm(),
                    const LoginWith(),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/login_01.png',
                            height: 60.h,
                          ),
                          SizedBox(
                            width: aDefaultPadding.w,
                          ),
                          Image.asset(
                            'asset/login_02.png',
                            height: 60.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}