import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:templates_flutter_app/controllers/auth_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/widget/loading_screen.dart';

class RegisterTercerd extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final AuthController authController = AuthController();

  RegisterTercerd({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthUserProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) return const LoadScreen();

        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('asset/login_01.png', height: 50),
              const SizedBox(width: aDefaultPadding),
              GestureDetector(
                onTap: () {
                  authController.signInGoogle(googleSignIn, context);
                },
                child: Image.asset('asset/login_02.png', height: 50),
              ),
            ],
          ),
        );
      },
    );
  }
}
