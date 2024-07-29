// ignore_for_file: unused_element, non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/screens/home/widget/home_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_type_content.dart';
import 'package:templates_flutter_app/screens/sidebar/sidebar_screen.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoggedIn = false;
  String username = '';
  @override
  initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
        username = user.displayName ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Mi Aplicación'),
      ),
      drawer: Sidebar(
        isLoggedIn: isLoggedIn,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const HomeTypeContent(
            title: 'Choose a Category',
          ),
          HomeContent(
            isLoggedIn: isLoggedIn,
          )
        ],
      ),
    );
  }
}