import 'package:flutter/material.dart';
import 'package:templates_flutter_app/services/auth_services.dart';

class AuthController {
  // Método para hacer login
  Future<void> loginUser(
      String email, String password, BuildContext context, formKey) async {
    await AuthServices().loginUser(email, password, context, formKey);
  }

  Future<void> registerUser(String username, String email, String password,
      BuildContext context, formKey) async {
    AuthServices().registerUser(username, email, password, formKey);
  }

  Future<void> logoutUser(
      String email, String password, BuildContext context, formKey) async {
    await AuthServices().logoutUser(context);
  }
}
