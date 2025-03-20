import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
        surface: const Color(0xFF050517),
        primary: const Color.fromARGB(255, 122, 122, 122),
        secondary: const Color.fromARGB(255, 30, 30, 30),
        onPrimaryContainer: Colors.white,
        onTertiary: const Color.fromARGB(255, 204, 204, 205).withOpacity(.5),
        tertiary: const Color.fromARGB(255, 255, 255, 255),
        tertiaryFixed: const Color.fromARGB(255, 1, 1, 31).withOpacity(.9),
        inversePrimary: Colors.grey.shade300));
