import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';

class ProviderService {
  Future<void> initializeProviders(BuildContext context) async {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    final subscriptionProvider =
        Provider.of<SuscriptionProvider>(context, listen: false);

    await authProvider.checkLoginStatus();

    if (authProvider.isLogged && subscriptionProvider.isSuscribed) {
      final userId = authProvider.getUserId().toString();
      // ignore: use_build_context_synchronously
      await subscriptionProvider.startSubscriptionGlobal(userId, context);
    }
  }
}
