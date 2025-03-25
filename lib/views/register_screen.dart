import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/auth_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/widget/button01.dart';
import 'package:templates_flutter_app/widget/loading_screen.dart';
import 'package:templates_flutter_app/widget/login_with.dart';
import 'package:templates_flutter_app/widget/register_tercerd.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameField = TextEditingController();
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  bool obscureText = true;
  final AuthController registerController = AuthController();
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
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SafeArea(
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: usernameField,
                      decoration: _buildInputDecoration('Username'),
                    ),
                    const SizedBox(height: 30),
                    // Campo de email
                    TextFormField(
                      controller: emailField,
                      decoration: _buildInputDecoration('Email'),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 30),

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
                            text: 'Registrarse',
                            onPressed: () async {
                              await registerController.registerUser(
                                usernameField.text.trim(),
                                emailField.text.trim(),
                                passwordField.text.trim(),
                                context,
                                _formKey,
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



/*
return Material(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            child: const Icon(Icons.arrow_back_rounded)),
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .8,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameField,
                    decoration: InputDecoration(
                      labelText: 'Enter your username',
                      errorText: usernameField.text.isEmpty
                          ? 'Please enter a valid username'
                          : null,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                      labelStyle: const TextStyle(color: Colors.black26),
                      fillColor: const Color(0xFFF3F3F3),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: emailField,
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      errorText: emailField.text.isEmpty ||
                              !emailField.text.contains('@') ||
                              !emailField.text.contains('.')
                          ? 'Please enter a valid email'
                          : null,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                      labelStyle: const TextStyle(color: Colors.black26),
                      fillColor: const Color(0xFFF3F3F3),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: passwordField,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined),
                      ),
                      labelText: 'Enter your Password',
                      errorText: passwordField.text.isEmpty ||
                              passwordField.text.length < 8
                          ? 'Please enter your passord max 8 caracter'
                          : null,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                      labelStyle: const TextStyle(color: Colors.black26),
                      fillColor: const Color(0xFFF3F3F3),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String username = usernameField.text;
                        String email = emailField.text;
                        String password = passwordField.text;
                        await registerController.registerUser(
                            username, email, password, context, _formKey);
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.only(
                                bottom: 50, left: 60, right: 50),
                            content: Text('Input required values'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
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
    ));
 */