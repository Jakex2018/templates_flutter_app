import 'package:flutter/material.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/views/payment_screen.dart';

class SuscriptionServices {
  Future<void> cancelSubscription(BuildContext context, String? userId,
      SuscriptionProvider subscriptionProvider, suscription) async {
    if (subscriptionProvider.isSuscribed) {
      // Lógica para cancelar la suscripción
      await dialogCancelSuscription(context, userId, subscriptionProvider);
    } else {
      // Si no está suscrito, redirige al pago
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(suscription: suscription),
        ),
      );
    }
  }
  void handleSubscription(BuildContext context, SuscriptionModel suscription) {
  if (suscription.cat == SuscriptionCat.premium) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(suscription: suscription),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You have Default Free Account'),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}

  Future<dynamic> dialogMemberSuscription(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You have a Member Suscription'),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<dynamic> dialogCancelSuscription(BuildContext context, String? userId,
      SuscriptionProvider subscriptionProvider) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want cancel Suscription?'),
        actions: [
          MaterialButton(
              onPressed: () async {
                if (userId != null) {
                  subscriptionProvider.cancelSuscription(
                      userId, subscriptionProvider.suscriptionEndDate);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
                      content: Text('Subscription canceled successfully.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
                      content: Text(
                          'Failed to cancel subscription: User ID is null.'),
                    ),
                  );
                }

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ));
              },
              child: const Text("Ok")),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
