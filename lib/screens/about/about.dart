import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';

class About extends StatelessWidget {
  const About({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeBackground(
        title: 'Hello,Armando!!',
        desc: 'It s time for build your dream\napplication',
        sidebarIcon: Icons.menu,
      ),
    );
  }
}