import 'package:flutter/material.dart';

class LoginWith extends StatelessWidget {
  const LoginWith({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 70,
            height: 1.5,
            color: Colors.black38,
          ),
          Text(
            'Or Signin with',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: 70,
            height: 1.5,
            color: Colors.black38,
          )
        ],
      ),
    );
  }
}