import 'package:flutter/material.dart';
//import 'package:gif_view/gif_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;

  const CustomAppBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My App'),
      leading: IconButton(
        icon: Icon(Icons.menu), // Asegúrate de que esté usando Icons.menu
        onPressed: onTap,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
