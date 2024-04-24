import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/about/about.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';
import 'package:templates_flutter_app/screens/sidebar/sidebar_screen.dart';

Widget getScreen(MenuItem currentItem) {
  switch (currentItem) {
    case MenuItems.about:
      return const About();
    case MenuItems.register:
      return const RegisterScreen();
    case MenuItems.chat:
      return const About();
    case MenuItems.login:
      return const LoginScreen();
    case MenuItems.home:
    default:
      return const Home();
  }
}
