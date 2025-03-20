import 'package:flutter/material.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';

class ErrorCategoryImage extends StatelessWidget {
  const ErrorCategoryImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: aDefaultPadding * 2,
          vertical: aDefaultPadding,
        ),
        child: Container(
          height: 210,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black54, width: 2)),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 54),
              SizedBox(
                height: 5,
              ),
              const Text(
                'Please, Connect your Internet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ));
  }
}