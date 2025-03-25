class SplashController {
  void redirect(Function() onRedirect) {
    Future.delayed(const Duration(seconds: 3), onRedirect);
  }

  void dispose() {
    // Limpiar recursos si es necesario
  }
}
