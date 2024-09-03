import 'package:flutter/material.dart';
import 'package:templates_flutter_app/constants.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
        background: Colors.grey.shade300,
        primary: Colors.grey.shade500,
        onTertiary: kblueColor.withOpacity(.73),
        secondary: Colors.grey.shade100,
        tertiary: Colors.white,
        onPrimaryContainer: Colors.black,
        inversePrimary: Colors.grey.shade700));
