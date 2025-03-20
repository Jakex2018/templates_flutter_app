import 'package:flutter/material.dart';

class HomeController {
  late AnimationController controller;
  late Animation<double> fadeInAnimation;
  late Animation<Offset> offsetAnimation;

  void initializeAnimations(TickerProvider tickerProvider) {
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: tickerProvider,
    );

    fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );

    offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    // Inicia la animación
    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}
