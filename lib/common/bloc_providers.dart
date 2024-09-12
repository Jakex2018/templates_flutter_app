import 'package:provider/provider.dart';
import 'package:templates_flutter_app/main.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';
import 'package:templates_flutter_app/themes/theme_provider.dart';

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
