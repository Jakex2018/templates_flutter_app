import 'package:flutter/material.dart';

class SideBarLink extends StatelessWidget {
  const SideBarLink({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    required this.isDarkMode,
  });
  final bool isDarkMode;
  final String title;
  final VoidCallback onTap;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}