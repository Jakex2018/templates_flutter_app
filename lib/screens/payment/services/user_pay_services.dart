// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/order/order_screen.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';

Future<void> userPay(BuildContext context) async {
  final subscriptionProvider =
      Provider.of<SuscriptionProvider>(context, listen: false);

  final auth = FirebaseAuth.instance;
  final userId = auth.currentUser?.uid;

  //save subscribe
  if (userId != null) {
    final expiryTime = DateTime.now().add(const Duration(seconds: 60));

    final nowTime = DateTime.now();

    await subscriptionProvider.activateSubscription(
        userId, true, nowTime, expiryTime);

    // subscriptionProvider.setSuscription(true);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
      content: Text('Suscription Successfully'),
    ),
  );

  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const OrderScreen()));
}
