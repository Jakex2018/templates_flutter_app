import 'package:flutter/material.dart';
//import 'package:gif_view/gif_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.onTap,
  });
  final Widget? title;

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      /*
      GifView.asset(
        'asset/bg_01_animate.gif',
        fit: BoxFit.cover,
         width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
       */
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.tertiaryFixed,
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              )),
          title: title ?? const Text(''),
          centerTitle: true,
        ),
      ),
    ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
