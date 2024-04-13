// ignore_for_file: use_super_parameters
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/sidebar/widget/sidebar_link.dart';

class MenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const login = MenuItem('Login', Icons.login_outlined);
  static const about = MenuItem(
    'About',
    Icons.add_box_outlined,
  );
  static const chat = MenuItem(
    'Chat Bot',
    Icons.chat_bubble,
  );
  static const all = <MenuItem>[home, about, chat];
  static const allLogin = <MenuItem>[login];
}

class MenuItem {
  final String title;
  final IconData icon;
  const MenuItem(this.title, this.icon);
}

class SidebarScreen extends StatefulWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectItem;
  const SidebarScreen(
      {super.key, required this.currentItem, required this.onSelectItem});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  bool _isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: _isDarkMode ? Colors.black : Colors.white,
      borderRadius: BorderRadius.only(topRight: Radius.circular(30.sp)),
      child: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: aDefaultPadding, vertical: aDefaultPadding * 2),
        children: [
          ListTile(
            title: Text(
              'User: not found\nPlease Login your account',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 70.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...MenuItems.all.map(buildMenuItem),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(255, 233, 235, 235), width: 2))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: Column(
                children: [
                  ...MenuItems.allLogin.map(buildMenuItem),
                  SizedBox(
                    height: 20.h,
                  ),
                  SideBarLink(
                    title: 'Dark Mode',
                    onTap: () {
                      setState(() => _isDarkMode = !_isDarkMode);
                    },
                    icon: Icon(
                      _isDarkMode ? Icons.sunny : Icons.dark_mode_rounded,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    isDarkMode: _isDarkMode,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(MenuItem item) => ListTileTheme(
        selectedColor: _isDarkMode ? Colors.white : Colors.black,
        child: ListTile(
          selectedTileColor: _isDarkMode ? Colors.white24 : Colors.black26,
          selected: widget.currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(
            item.icon,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            item.title,
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () => widget.onSelectItem(item),
        ),
      );
}


/*
// ignore_for_file: use_super_parameters
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/sidebar/widget/sidebar_link.dart';

class MenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const about = MenuItem(
    'About',
    Icons.add_box_outlined,
  );
  static const chat = MenuItem(
    'Chat Bot',
    Icons.chat_bubble,
  );
  static const all = <MenuItem>[home, about, chat];
}

class MenuItem {
  final String title;
  final IconData icon;
  const MenuItem(this.title, this.icon);
}

class SidebarScreen extends StatefulWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectItem;
  const SidebarScreen(
      {super.key, required this.currentItem, required this.onSelectItem});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  bool _isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: _isDarkMode ? Colors.black : Colors.white,
      borderRadius: BorderRadius.only(topRight: Radius.circular(30.sp)),
      child: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: aDefaultPadding, vertical: aDefaultPadding * 2),
        children: [
          ListTile(
            title: Text(
              'User: not found\nPlease Login your account',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 70.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...MenuItems.all.map(buildMenuItem),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(255, 233, 235, 235), width: 2))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: Column(
                children: [
                  SideBarLink(
                    title: 'Login',
                    onTap: () {
                      Navigator.push(context, e);
                    },
                    icon: Icon(
                      Icons.login_rounded,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    isDarkMode: _isDarkMode,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SideBarLink(
                    title: 'Dark Mode',
                    onTap: () {
                      setState(() => _isDarkMode = !_isDarkMode);
                    },
                    icon: Icon(
                      _isDarkMode ? Icons.sunny : Icons.dark_mode_rounded,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    isDarkMode: _isDarkMode,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(MenuItem item) => ListTileTheme(
        selectedColor: _isDarkMode ? Colors.white : Colors.black,
        child: ListTile(
          selectedTileColor: _isDarkMode ? Colors.white24 : Colors.black26,
          selected: widget.currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(
            item.icon,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            item.title,
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () => widget.onSelectItem(item),
        ),
      );
}

 */