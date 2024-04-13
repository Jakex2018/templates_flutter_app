import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/home/widget/home_card.dart';

class HomeContainerChoose extends StatelessWidget {
  const HomeContainerChoose({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: aDefaultPadding * .9),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < 2; i++) const HomeCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}