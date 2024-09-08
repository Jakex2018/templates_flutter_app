import 'package:flutter/material.dart';
import 'package:templates_flutter_app/themes/dark_mode.dart';
import 'package:templates_flutter_app/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toogleTheme() async {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
