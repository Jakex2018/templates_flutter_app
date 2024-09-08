import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTypeContent extends StatelessWidget {
  const HomeTypeContent({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        border: Border.all(color: Colors.white12),
      ),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
      )),
    );
  }
}
