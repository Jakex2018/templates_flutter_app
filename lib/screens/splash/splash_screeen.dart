import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:templates_flutter_app/constants.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(
            'asset/bg-splash.svg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: aDefaultPadding * 2.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  fit: BoxFit.cover,
                  'asset/logo_flutter.svg',
                  // ignore: deprecated_member_use
                  color: Colors.blue.shade400,
                  height: 70,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  child: Text(
                    ' Templates',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    if (mounted) Navigator.pushNamed(context, '/home');
  }
}
