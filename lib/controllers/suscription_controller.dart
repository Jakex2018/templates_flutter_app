import 'package:flutter/material.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/suscription_services.dart';

class SuscriptionController {
  final SuscriptionProvider subscriptionProvider;
  final SuscriptionServices subscriptionServices;

  SuscriptionController({
    required this.subscriptionProvider,
    required this.subscriptionServices,
  });

  bool get isSuscribed => subscriptionProvider.isSuscribed;
  Future<void> cancelSubscription(BuildContext context, String? userId,
      SuscriptionModel suscription) async {
    await subscriptionServices.cancelSubscription(
        context, userId, subscriptionProvider, suscription);
  }

  Future<void> handleSubscription(
      BuildContext context, SuscriptionModel suscription) async {
    subscriptionServices.handleSubscription(context, suscription);
  }
}
