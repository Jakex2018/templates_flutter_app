import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/views/register_screen.dart';
import 'package:templates_flutter_app/views/suscription_screen.dart';
import 'package:templates_flutter_app/providers/theme_provider.dart';
import 'package:templates_flutter_app/widget/sidebar_link.dart';

// ignore: must_be_immutable
class Sidebar extends StatefulWidget {
  Sidebar({super.key, required this.isLoggedIn, required this.username});
  AuthUserProvider isLoggedIn;
  String username;
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      widget.username = user?.displayName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 230,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(offset: Offset(0, 15), spreadRadius: 5, blurRadius: 10)
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: _sidebarBody(themeProvider),
    );
  }

  Widget _sidebarBody(ThemeProvider themeProvider) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          linkNotUser(context),
          if (widget.isLoggedIn.isLogged) linkToUser(context),
          themeModeOption(themeProvider),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      child: Center(
        child: Text(
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          !widget.isLoggedIn.isLogged
              ? 'Hola, Invitado!'
              : widget.username.isNotEmpty
                  ? 'Hola, ${widget.username}'
                  : 'Hola, Invitado!',
        ),
      ),
    );
  }

  Padding themeModeOption(ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 300),
      child: Row(
        children: [
          Selector<ThemeProvider, bool>(
            selector: (context, themeProvider) => themeProvider.isDarkMode,
            builder: (context, value, child) {
              return CupertinoSwitch(
                value: value,
                onChanged: (value) {
                  themeProvider.toogleTheme();
                },
              );
            },
          ),
          const SizedBox(width: 10),
          const Text(
            'Dark Mode',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget linkToUser(BuildContext context) {
    return Column(
      children: [
        SideBarLink(
          title: 'Logout',
          onTap: () async {
            final authProvider =
                Provider.of<AuthUserProvider>(context, listen: false);
            final connectivityResult =
                await (Connectivity().checkConnectivity());
            // ignore: unrelated_type_equality_checks
            if (connectivityResult == ConnectivityResult.none) {
              Fluttertoast.showToast(
                msg: 'No internet connection.',
                toastLength: Toast.LENGTH_SHORT,
                // ... other toast configuration
              );
              return; // Prevent further execution if no internet
            }
            try {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              authProvider.setLoggedIn(false);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 4),
                  margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
                  content: Text('Logout Successfully'),
                ),
              );

              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
                (Route<dynamic> route) => false,
              );
            } on FirebaseAuthException {
              Fluttertoast.showToast(
                msg: 'Please connect Internet.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          icon: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        SideBarLink(
          title: 'Suscription',
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuscriptionScreen(),
                ));
          },
          icon: Icon(
            Icons.sell,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
    );
  }

  Column linkNotUser(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isLoggedIn.isLogged)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SideBarLink(
                title: 'Iniciar Sesion',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
                icon: Icon(
                  Icons.login,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              SideBarLink(
                title: 'Registrarse',
                onTap: () {
                  ///Navigator.pop(context);
                  Navigator.pushNamed(context, '/register');
                },
                icon: Icon(
                  Icons.supervised_user_circle_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              SideBarLink(
                title: 'Chat Bot',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ));
                },
                icon: Icon(
                  Icons.chat_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          )
      ],
    );
  }
}
