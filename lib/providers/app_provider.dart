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

class AppProvider {
  static get allProviders => [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        Provider<HomeController>(
          create: (context) => HomeController(
            loadingService: context.read<LoadingService>(),
            providerService: context.read<ProviderService>(),
            connectivityService: context
                .read<ConnectivityService>(), // Inyectamos ConnectivityService
            authUserProvider: context.read<AuthUserProvider>(),
          ),
        ),

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
        ChangeNotifierProvider<CategoryController>(
          create: (context) => CategoryControllerImpl(
            templateService: TemplateDataService(),
            connectivityService: ConnectivityService(),
          ),
        ),
        // Aquí solo mantenemos la implementación concreta, CategoryControllerImpl.

        Provider<AdService>(
          // Aquí
          create: (context) => AdService(),
        ),
      ];
}
