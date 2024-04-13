// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:templates_flutter_app/common/routes/name.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:templates_flutter_app/screens/sidebar/sidebar_screen.dart';

/*CONNECT FIREBASE */

Future<void> main() async {
  await Global.init();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MenuItem currentItem = MenuItems.home;
  final controller = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ZoomDrawer(
            menuScreen: Builder(
              builder: (context) => SidebarScreen(
                  currentItem: currentItem,
                  onSelectItem: (item) {
                    setState(() => currentItem = item);
                    ZoomDrawer.of(context)!.close();
                  }),
            ),
            showShadow: true,
            style: DrawerStyle.style1,
            controller: controller,
            slideHeight: MediaQuery.of(context).size.height,
            mainScreen: getScreen(currentItem)),
      ),
    );
  }
}