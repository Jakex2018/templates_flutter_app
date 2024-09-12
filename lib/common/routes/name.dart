import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';
import 'package:templates_flutter_app/screens/splash/splash_screeen.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';

final routes = <String, WidgetBuilder>{
  '/splash': (context) => const SplashScreeen(),
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/register': (context) => const RegisterScreen(),
  '/suscription': (context) => const SuscriptionScreen()
};
