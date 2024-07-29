import 'package:flutter/material.dart';

import 'package:templates_flutter_app/screens/about/about.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';

Widget getScreen(String name) {
  switch (name) {
    case 'about':
      return const About();
    case 'register':
      return const RegisterScreen();

    case 'login':
      return const Login();
    default:
      return const Home(); // Assuming a default Home screen
  }
}


/*
Widget getScreen(
    MenuItem currentItem,bool user) {
  switch (currentItem) {
    case MenuItems.about:
      return const About();
    case MenuItems.register:
      return const RegisterScreen();
    case MenuItems.chat:
      return const About();
    case MenuItems.login:
      return const LoginScreen();

    default:
      return Home(
        user: user,
      );
  }
}

 */
