import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/home/widget/home_container_choose.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 470.h,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: const SingleChildScrollView(
        child: HomeContainerChoose(),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/home/widget/home_container_choose.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 470.h,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: const SingleChildScrollView(
        child: Column(
          children: [
            HomeContainerChoose(
              title: 'Most Recommend',
            ),
            HomeContainerChoose(
              title: 'Most Popular',
            ),
            HomeContainerChoose(
              title: 'Content Premium',
            ),
          ],
        ),
      ),
    );
  }
}
 */