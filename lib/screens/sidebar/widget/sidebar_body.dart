import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';
import 'package:templates_flutter_app/screens/sidebar/widget/sidebar_link.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';
import 'package:templates_flutter_app/themes/theme_provider.dart';

// ignore: must_be_immutable
class SideBarBody extends StatefulWidget {
  SideBarBody(
      {super.key,
      //required this.isDarkMode,
      required this.isLoggedIn,
      required this.username});
  //bool isDarkMode;
  bool isLoggedIn;
  final String username;
  @override
  State<SideBarBody> createState() => _SideBarBodyState();
}

class _SideBarBodyState extends State<SideBarBody> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                widget.isLoggedIn == false
                    ? 'Hola, Invitado!'
                    : widget.username.isNotEmpty
                        ? 'Hola,${widget.username}'
                        : 'Hola, Invitado!',
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isLoggedIn)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SideBarLink(
                      title: 'Iniciar Sesion',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      },
                      icon: Icon(
                        Icons.login,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    SideBarLink(
                      title: 'Registrarse',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ));
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
          ),
          if (widget.isLoggedIn)
            Column(
              children: [
                SideBarLink(
                  title: 'Logout',
                  onTap: () async {
                    final connectivityResult =
                        await (Connectivity().checkConnectivity());
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
                      setState(() {
                        widget.isLoggedIn = false;
                      });
                      Fluttertoast.showToast(
                        msg: 'Logout Successfully',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1, // 1 second for iOS/Web
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ));
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
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 300.h),
            child: Row(
              children: [
                Selector<ThemeProvider, bool>(
                  selector: (context, themeProvider) =>
                      themeProvider.isDarkMode,
                  builder: (context, value, child) {
                    return CupertinoSwitch(
                      value: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toogleTheme();
                      },
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
