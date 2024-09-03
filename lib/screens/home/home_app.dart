// ignore_for_file: unused_element, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/screens/home/widget/home_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_type_content.dart';
import 'package:templates_flutter_app/screens/sidebar/sidebar_screen.dart';

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
      appBar: AppBar(),
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


/*

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GifView(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        image: const AssetImage('asset/bg_01_animate.gif'),
        fit: BoxFit.cover,
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kblueColor.withOpacity(.75),
        child: Padding(
          padding: EdgeInsets.only(bottom: 30.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    size: 20.sp,
                    color: Colors.white,
                  )),
              Text(
                'Flutter Templates',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
*/

/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/constants.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(143.5.h),
        child: Stack(children: [
          GifView(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            image: const AssetImage('asset/bg_01_animate.gif'),
            fit: BoxFit.cover,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kblueColor.withOpacity(.73),
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.openDrawer(); 
                      },
                      icon: Icon(
                        Icons.menu,size: 20.sp,
                        color: Colors.white,
                      )),
                  Text(
                    'Flutter Templates',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
      drawer: Sidebar(isLoggedIn: isLoggedIn, username: username),
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
 */