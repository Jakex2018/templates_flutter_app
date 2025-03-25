import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/auth_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/widget/button01.dart';
import 'package:templates_flutter_app/widget/loading_screen.dart';
import 'package:templates_flutter_app/widget/login_with.dart';
import 'package:templates_flutter_app/widget/register_tercerd.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ... (variables y controladores existentes)
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  bool obscureText = true;
  final AuthController loginController = AuthController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    if (authProvider.isLoading) {
      return const LoadScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SafeArea(
            child: IntrinsicHeight(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo de email
                    TextFormField(
                      controller: emailField,
                      decoration: _buildInputDecoration('Email'),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Campo de contraseña
                    TextFormField(
                      controller: passwordField,
                      obscureText: obscureText,
                      decoration: _buildInputDecoration('Contraseña').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => obscureText = !obscureText),
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 30),

                    // Botón de login
                    SizedBox(
                        width: double.infinity,
                        child: ButtonOne(
                            text: 'Iniciar Sesion',
                            onPressed: () async {
                              await loginController.loginUser(
                                emailField.text.trim(),
                                passwordField.text.trim(),
                                context,
                                formKey,
                              );
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.onTertiary)),

                    const LoginWith(),
                    RegisterTercerd(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Ingrese un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }
}






/**
 * /class _LoginState extends State<Login> {
  // ... (mantén tus controladores y variables existentes)
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  bool obscureText = true;
  final AuthController loginController = AuthController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    if (authProvider.isLoading) {
      return const LoadScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home())),
        ),
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight! -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Campo de email
                      TextFormField(
                        controller: emailField,
                        decoration: _buildInputDecoration('Email'),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),

                      // Campo de contraseña
                      TextFormField(
                        controller: passwordField,
                        obscureText: obscureText,
                        decoration:
                            _buildInputDecoration('Contraseña').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => obscureText = !obscureText),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 30),

                      // Botón de login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await loginController.loginUser(
                              emailField.text.trim(),
                              passwordField.text.trim(),
                              context,
                              formKey,
                            );
                          },
                          child: const Text('Iniciar sesión'),
                        ),
                      ),

                      const LoginWith(),
                      const RegisterTercerd(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Ingrese un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }
}
 */