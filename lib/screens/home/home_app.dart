// ignore_for_file: unused_element, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/main.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/screens/home/widget/home_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_type_content.dart';
import 'package:templates_flutter_app/screens/sidebar/sidebar_screen.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';
import 'package:templates_flutter_app/widget/custom_app_bar.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String username = '';
  @override
  @override
  void initState() {
    super.initState();
    Provider.of<AuthUserProvider>(context, listen: false).checkLoginStatus();
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    authProvider.checkLoginStatus().then((_) {
      if (authProvider.isLogged) {
        final subscriptionProvider =
            // ignore: use_build_context_synchronously
            Provider.of<SuscriptionProvider>(context, listen: false);
        subscriptionProvider.loadSubscriptionState(
            'userId'); // Asegúrate de pasar el userId correcto
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(onTap: () => scaffoldKey.currentState!.openDrawer()),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HomeTypeContent(
            title: 'Choose a Category',
          ),
          HomeContent()
        ],
      ),
      drawer: Sidebar(isLoggedIn: authProvider, username: username),
    );
  }
}



/*
// ignore_for_file: unused_element, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/screens/home/widget/home_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_type_content.dart';
import 'package:templates_flutter_app/screens/sidebar/sidebar_screen.dart';
import 'package:templates_flutter_app/widget/custom_app_bar.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isLoggedIn = false;
  String username = '';
  @override
  initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> _saveLoginStatus(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', loggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(onTap: () => scaffoldKey.currentState!.openDrawer()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HomeTypeContent(
            title: 'Choose a Category',
          ),
          HomeContent(
            isLoggedIn: isLoggedIn,
          )
        ],
      ),
      drawer: Sidebar(isLoggedIn: isLoggedIn, username: username),
    );
  }
}
 */