import 'package:flutter/material.dart';
import 'package:templates_flutter_app/services/auth_services.dart';

class AuthController extends ChangeNotifier {
  final AuthServices authServices;

  // Constructor con inyección de dependencias
  AuthController({AuthServices? authServices})
      : authServices = authServices ?? AuthServices();

  // Método para hacer login
  Future<void> loginUser(
      String email, String password, BuildContext context, formKey) async {
    await authServices.loginUser(email, password, context, formKey);
  }

  Future<void> registerUser(String username, String email, String password,
      BuildContext context, formKey) async {
    await authServices.registerUser(
        username, email, password, context, formKey);
  }

  Future<void> logoutUser(BuildContext context) async {
    await authServices.logoutUser(context);
  }
}
