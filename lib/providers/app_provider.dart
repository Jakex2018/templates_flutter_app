import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/auth_controller.dart';
import 'package:templates_flutter_app/controllers/category_controller.dart';
import 'package:templates_flutter_app/controllers/home_controller.dart';
import 'package:templates_flutter_app/controllers/payment_controller.dart';
import 'package:templates_flutter_app/models/connectivity_model.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/providers/payment_provider.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/providers/theme_provider.dart';
import 'package:templates_flutter_app/services/ad_services.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/services/loading_services.dart';
import 'package:templates_flutter_app/services/provider_services.dart';
import 'package:templates_flutter_app/services/template_data_services.dart';
import 'package:templates_flutter_app/views/home_app.dart';

class AppProvider {
  static get allProviders => [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),

        // Ensure ProviderService is provided first
        Provider<ProviderService>(create: (_) => ProviderService()),
        Provider<LoadingService>(create: (_) => LoadingService()),
        Provider<ConnectivityService>(create: (_) => ConnectivityService()),

        ChangeNotifierProvider(
          create: (context) => ConnectivityModel()..initConnectivity(),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PaymentMethodProvider()),
        ChangeNotifierProvider(create: (context) => AuthUserProvider()),
        ChangeNotifierProxyProvider<AuthUserProvider, SuscriptionProvider>(
          create: (context) => SuscriptionProvider(),
          update: (context, authProvider, subscriptionProvider) {
            subscriptionProvider
                ?.loadSubscriptionState(authProvider.isLogged ? 'userId' : '');
            return subscriptionProvider!;
          },
        ),
        ChangeNotifierProvider<CategoryController>(
          create: (context) => CategoryController(
            templateService: TemplateDataService(),
            connectivityService: ConnectivityService(),
          ),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (context) => HomeController(
            providerService: context.read<ProviderService>(),
            connectivityService: context.read<ConnectivityService>(),
            loadingService: context.read<LoadingService>(),
          ),
          child: Home(),
        ),
        Provider<AdService>(create: (context) => AdService()),
        
      ];
}
