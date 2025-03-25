import 'package:flutter/material.dart';

//import 'package:gif_view/gif_view.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;

  const CustomAppBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'asset/bg_01_animate.gif',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .24,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.tertiaryFixed.withOpacity(.8),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, size: 30),
        color: Theme.of(context).colorScheme.primary,
        onPressed: onTap,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
