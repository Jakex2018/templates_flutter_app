import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/services/auth_services.dart';
import 'package:templates_flutter_app/views/home_app.dart';

class RegisterTercerd extends StatefulWidget {
  const RegisterTercerd({
    super.key,
  });

  @override
  State<RegisterTercerd> createState() => _RegisterTercerdState();
}

class _RegisterTercerdState extends State<RegisterTercerd> {
  @override
  Widget build(BuildContext context) {
    final AuthServices authServices = AuthServices();
    final authProvider = Provider.of<AuthUserProvider>(context);

    final GoogleSignIn googleSignIn = GoogleSignIn();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/login_01.png',
            color: Theme.of(context).colorScheme.inversePrimary,
            height: 50,
          ),
          SizedBox(
            width: aDefaultPadding,
          ),
          GestureDetector(
            onTap: () async {
              await authServices.signInGoogle(
                  googleSignIn, authProvider, context);
              // ignore: use_build_context_synchronously
              navigateHome(context);
            },
            child: Image.asset(
              'asset/login_02.png',
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  void navigateHome(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ));
  }
}