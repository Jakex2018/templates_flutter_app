import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  int _time = 60;
  int get time => _time;
  Timer? timer;
  void startTime() {
    Timer.periodic(const Duration(seconds: 1), (time) {
      _time--;
      notifyListeners();
      if (_time == 0) {
        timer?.cancel();
      }
    });
  }

  late BuildContext _context;

  BuildContext get context => _context;
  set context(BuildContext newContext) {
    _context = newContext;
    notifyListeners();
  }
}

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

