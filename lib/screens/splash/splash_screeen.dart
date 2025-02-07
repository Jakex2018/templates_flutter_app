import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duración de la animación
    );

    // Define la animación de opacidad
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Establece una curva suave
      ),
    );

    // Inicia la animación
    _controller.forward();

    // Llama a la función de redirección después de la animación
    Future.delayed(const Duration(seconds: 2), () {
      redirect();
    });
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
          FadeTransition(
            opacity: _animation,
            child: Center(
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
          ),
        ],
      ),
    );
  }

  // Función para redirigir
  Future<void> redirect() async {
    if (mounted) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
