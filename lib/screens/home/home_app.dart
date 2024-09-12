// ignore_for_file: unused_element, non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    Provider.of<AuthUserProvider>(context, listen: false).checkLoginStatus();
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    final subscriptionProvider =
        Provider.of<SuscriptionProvider>(context, listen: false);

    authProvider.checkLoginStatus().then((_) {
      if (authProvider.isLogged) {
        if (subscriptionProvider.isSuscribed == true) {
          final userId = authProvider.userId;
          //print('USERID $userId');

          if (mounted) {
            subscriptionProvider.startSubscriptionGlobal(userId!, context);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
