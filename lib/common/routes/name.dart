import 'package:flutter/material.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/views/login_screen.dart';
import 'package:templates_flutter_app/views/register_screen.dart';
import 'package:templates_flutter_app/views/splash_screeen.dart';
import 'package:templates_flutter_app/views/suscription_screen.dart';

final routes = <String, WidgetBuilder>{
  '/splash': (context) => const SplashScreeen(),
  '/home': (context) => const Home(),
  '/login': (context) => const Login(),
  '/register': (context) => const RegisterScreen(),
  '/suscription': (context) => const SuscriptionScreen()

};


