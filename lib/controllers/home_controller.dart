import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/services/loading_services.dart';
import 'package:templates_flutter_app/services/provider_services.dart';

class HomeController {
  final LoadingService _loadingService = LoadingService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final ProviderService _providerService = ProviderService();

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityService.connectivityStream;

  Future<void> initialize(BuildContext context) async {
    _providerService.initializeProviders(context);
    await _loadingService.simulateLoading();
  }

  void dispose() {
    // Limpiar recursos si es necesario
  }
}