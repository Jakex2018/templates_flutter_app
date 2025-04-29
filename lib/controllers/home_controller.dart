import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/services/loading_services.dart';
import 'package:templates_flutter_app/services/provider_services.dart';

class HomeController extends ChangeNotifier {
  bool _isLoading = true;
  String _username = "";
  bool _showProgress = true;

  final LoadingService _loadingService;
  final ConnectivityService _connectivityService;
  final ProviderService _providerService;

  bool get isLoading => _isLoading;
  String get username => _username;
  bool get showProgress => _showProgress;
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityService.connectivityStream;

  HomeController({
    required LoadingService loadingService,
    required ConnectivityService connectivityService,
    required ProviderService providerService,
  })  : _loadingService = loadingService,
        _connectivityService = connectivityService,
        _providerService = providerService;

  Future<void> initialize(BuildContext context) async {
    await _providerService.initializeProviders(context);
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    _username = authProvider.username ?? "";
    notifyListeners();
  }

  Future<void> simulateLoading() async {
    await _loadingService.simulateLoading();
    _isLoading = false;
    notifyListeners();
  }

  void toggleProgress() {
    _showProgress = !_showProgress;
    notifyListeners();
  }
}
