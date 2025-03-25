import 'package:flutter/material.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/services/provider_services.dart';

class HomeController extends ChangeNotifier {
  final ProviderService? _providerService;
  final ConnectivityService?
      _connectivityService; // Agregamos la dependencia de ConnectivityService

  HomeController({
    ProviderService? providerService,
    ConnectivityService? connectivityService, // Recibimos la dependencia aquí
    AuthUserProvider? authUserProvider,
  })  : _providerService = providerService,
        _connectivityService =
            connectivityService; // Inicializamos la nueva propiedad

  // Exponiendo _providerService para acceder desde fuera de la clase
  ProviderService? get providerService => _providerService;

  // Exponiendo _connectivityService para acceder desde fuera de la clase
  ConnectivityService? get connectivityService => _connectivityService;

  Future<void> initialize(BuildContext context) async {
    _providerService?.initializeProviders(context);
  }

}
