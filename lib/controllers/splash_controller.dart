import 'package:flutter/material.dart';

class SplashController {
  late AnimationController _controller;

  void redirect(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      // Elimina la verificación de mounted
      if (Navigator.of(context).mounted) {
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  void dispose() {
    _controller.dispose();
  }
}
