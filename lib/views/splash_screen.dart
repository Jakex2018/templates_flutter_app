import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:templates_flutter_app/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late SplashController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashController();
    _controller?.redirect(() {
      // Redirigir a la siguiente pantalla
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de la splash
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              'asset/bg-splash.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Animación de la transición de opacidad
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    fit: BoxFit.cover,
                    'asset/logo_flutter.svg',
                    // ignore: deprecated_member_use
                    color: Colors.blue.shade400,
                    height: 70,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Templates',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
