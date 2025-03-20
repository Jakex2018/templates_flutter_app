import 'dart:async';

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