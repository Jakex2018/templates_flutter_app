import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardLabel extends StatelessWidget {
  const CardLabel({
    super.key,
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: pi / 4,
        alignment: Alignment.center,
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          margin: const EdgeInsets.only(right: 50),
          decoration: BoxDecoration(
            color:
                type == "Free" ? Colors.red : Colors.yellow.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
