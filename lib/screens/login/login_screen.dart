import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/login/widget/login_Background.dart';
import 'package:templates_flutter_app/screens/login/widget/login_form.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                height: 545.h,
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
                          fontSize: 28.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Please register your information',
                      style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.black26,
                          fontWeight: FontWeight.bold),
                    ),
                    const LoginForm(),
                    const LoginWith(),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('asset/login_01.png'),
                        SizedBox(
                          width: aDefaultPadding.w,
                        ),
                        Image.asset('asset/login_02.png'),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Center(
                          child: RichText(
                        text: TextSpan(
                          text: 'You dont account, please click here',
                          style: const TextStyle(color: Colors.black26),
                          children: <TextSpan>[
                            TextSpan(
                                text: '  SIGNUP',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ));
                                  },
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue)),
                          ],
                        ),
                      )),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class LoginWith extends StatelessWidget {
  const LoginWith({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
