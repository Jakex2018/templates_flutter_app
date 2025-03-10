import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/sidebar/widget/sidebar_body.dart';
import 'package:templates_flutter_app/screens/auth/model/user_model.dart';

// ignore: must_be_immutable
class Sidebar extends StatefulWidget {
  Sidebar({super.key, required this.isLoggedIn, required this.username});
  AuthUserProvider isLoggedIn;
  String username;
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      widget.username = user?.displayName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: 230.w,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(offset: Offset(0, 15), spreadRadius: 5, blurRadius: 10)
        ], borderRadius: BorderRadius.circular(30.sp)),
        child: SideBarBody(
          isLoggedIn: widget.isLoggedIn,
          username: widget.username,
        ));
  }
}

 