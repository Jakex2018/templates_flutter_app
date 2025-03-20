// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color backgroundColor;
  final Color textColor;

  const ButtonOne({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      width: 180,
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold), // Adjust font size as needed
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Customize button shape
          ),
        ),
      ),
    );
  }
}
