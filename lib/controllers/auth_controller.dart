import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/services/auth_services.dart';

class AuthController extends ChangeNotifier {
  final AuthServices authServices;

  AuthController({AuthServices? authServices})
      : authServices = authServices ?? AuthServices();

  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    try {
      authProvider.setLoading(true);
      await authServices.loginUser(
          email, password, context, formKey, authProvider);
    } catch (e) {
      // Maneja el error (opcional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      authProvider.setLoading(false);
    }
  }

  Future<void> registerUser(String username, String email, String password,
      BuildContext context, formKey) async {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    try {
      authProvider.setLoading(true);
      await authServices.registerUser(
          username, email, password, context, formKey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      authProvider.setLoading(false);
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    await authServices.logoutUser(context);
  }

  Future<void> signInGoogle(
      GoogleSignIn googleSignIn, BuildContext context) async {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    await authServices.signInGoogle(googleSignIn, authProvider, context);
  }
}
