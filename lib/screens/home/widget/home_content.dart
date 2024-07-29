import 'package:flutter/material.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/home/widget/home_card.dart';

// ignore: must_be_immutable
class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.isLoggedIn});
  final bool isLoggedIn;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: aDefaultPadding * .9),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                HomeCard(isLoggedIn: isLoggedIn),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
