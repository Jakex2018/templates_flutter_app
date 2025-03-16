import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/providers/payment_provider.dart';
import 'package:templates_flutter_app/models/timer_model.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/providers/theme_provider.dart';

class AppProvider {
  // ignore: non_constant_identifier_names
  static get AllProviders => [
        ChangeNotifierProvider(
          create: (context) => ConnectivityModel()..initConnectivity(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentMethodProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SuscriptionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthUserProvider(),
        ),
        ChangeNotifierProxyProvider<AuthUserProvider, SuscriptionProvider>(
          create: (context) => SuscriptionProvider(),
          update: (context, authProvider, subscriptionProvider) {
            subscriptionProvider
                ?.loadSubscriptionState(authProvider.isLogged ? 'userId' : '');
            return subscriptionProvider!;
          },
        ),
      ];
}