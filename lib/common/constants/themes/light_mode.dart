import 'package:flutter/material.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';

final ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    onTertiary: const Color.fromARGB(255, 11, 11, 54),
    secondary: Colors.grey.shade100,
    tertiary: Colors.white,
    tertiaryFixed: kblueColor.withOpacity(.5),
    onPrimaryContainer: Colors.black,
    inversePrimary: Colors.grey.shade700,
  ),
);