import 'package:flutter/material.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/suscription_services.dart';

class SuscriptionController {
  final SuscriptionServices subscriptionServices;
  final SuscriptionProvider suscriptionProvider;

  SuscriptionController({
    required this.subscriptionServices,
    required this.suscriptionProvider,
  });

  Future<void> cancelSubscription(BuildContext context, String? userId,
      SuscriptionModel suscription) async {
    await subscriptionServices.cancelSubscription(
        context, userId, suscriptionProvider, suscription);
  }

  Future<void> handleSubscription(
      BuildContext context, SuscriptionModel suscription) async {
    subscriptionServices.handleSubscription(context, suscription);
  }
}