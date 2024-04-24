import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/suscription/widget/suscription_body.dart';

class SuscriptionScreen extends StatelessWidget {
  const SuscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Suscription'),
        centerTitle: true,
      ),
      body: const SuscriptionBody(),
    );
  }
}
