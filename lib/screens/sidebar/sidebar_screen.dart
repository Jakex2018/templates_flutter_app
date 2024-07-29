import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';
import 'package:templates_flutter_app/screens/sidebar/widget/sidebar_link.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isLoggedIn = false;
  String username = '';
  @override
  initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    //final prefs = await SharedPreferences.getInstance();
    //isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      isLoggedIn = user != null;
      username = user?.displayName ?? '';
    });
  }

  bool _isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    bool isLogged = widget.isLoggedIn;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 230.w,
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(offset: Offset(0, 5), blurRadius: 4)],
          borderRadius: BorderRadius.circular(30.sp)),
      child: Drawer(
        backgroundColor: _isDarkMode? Colors.black45:Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                isLoggedIn == false
                    ? 'Hola, Invitado!'
                    : username.isNotEmpty
                        ? 'Hola,$username'
                        : 'Hola, Invitado!',
              ),
            ),
            ListTile(
              title: Text('Dark Mode',style:TextStyle(color: _isDarkMode?Colors.black:Colors.white),),
              onTap: () {
                setState(() => _isDarkMode = !_isDarkMode);
              },
              leading: Icon(
                _isDarkMode ? Icons.sunny : Icons.dark_mode_rounded,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            if (isLogged)
              Column(
                children: [
                  SideBarLink(
                    title: 'Logout',
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                      setState(() {
                        isLogged = false;
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
                      Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ));
                    },
                    icon: Icon(
                      Icons.logout,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    isDarkMode: _isDarkMode,
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
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    isDarkMode: _isDarkMode,
                  ),
                ],
              )
            else if (!isLogged)
              Column(
                children: [
                  ListTile(
                    title: const Text('Iniciar Sesión'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          )); // Redirige a la pantalla de login
                    },
                  ),
                  ListTile(
                    title: const Text('Registrarse'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          )); // Redirige a la pantalla de login
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}