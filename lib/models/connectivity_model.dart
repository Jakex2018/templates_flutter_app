import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityModel extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;

  Future<void> initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _connectivityResult = result as ConnectivityResult;
      notifyListeners();
    } catch (e) {
      //print('Error al verificar la conectividad: $e');
    }
  }

  void onConnectivityChanged(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }
}
