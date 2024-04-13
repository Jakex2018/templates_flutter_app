import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
import 'package:templates_flutter_app/screens/home/widget/home_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_type_content.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        HomeBackground(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          title: 'Hello,Armando!!',
          desc: 'It s time for build your dream\napplication',
          sidebarIcon: Icons.menu,
        ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            HomeTypeContent(
              title: 'Choose a Category',
            ),
            HomeContent()
          ],
        ),
      ]),
    );
  }
}
