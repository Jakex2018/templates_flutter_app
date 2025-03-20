import 'package:flutter/material.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';

class RegisterWelcomeUser extends StatelessWidget {
  const RegisterWelcomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: aDefaultPadding * 1.2,
              horizontal: aDefaultPadding * 1.2),
          height: 560,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Please register your information',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black26,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
