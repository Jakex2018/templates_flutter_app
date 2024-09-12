import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

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
      GifView(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        image: const AssetImage('asset/bg_01_animate.gif'),
        fit: BoxFit.cover,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.tertiaryFixed,
        child: AppBar(
          /*Theme.of(context).colorScheme.surface, */
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


/*
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.title,
      required this.lead,
      required this.acti,
      this.ico,
      this.onTap,
      this.color});
  final Widget? title;
  final bool lead;
  final bool? acti;
  final IconData? ico;
  final Color? color;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Colors.transparent,
      title: title ?? const Text(''),
      centerTitle: true,
      leading: lead
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode
                        ? ColorsApp.darkGrey
                        : ColorsApp.lighBg),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 16,
                ),
              ))
          : null,
      actions: [
        if (acti != null) IconButton(onPressed: onTap, icon: Icon(ico))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

 */