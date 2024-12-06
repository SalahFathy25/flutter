import 'package:flutter/material.dart';

import '../../main.dart';

enum ThemeState { initial, light, dark }

class AppThemeProvider extends ChangeNotifier {
  ThemeState _themeState = ThemeState.initial;

  ThemeState get themeState => _themeState;

  AppThemeProvider() {
    _initializeTheme();
  }

  void _initializeTheme() {
    final theme = sharedPreferences.getString('theme');
    if (theme == 'light') {
      _themeState = ThemeState.light;
    } else if (theme == 'dark') {
      _themeState = ThemeState.dark;
    } else {
      _themeState = ThemeState.initial;
    }
    notifyListeners();
  }

  void changeTheme(ThemeState state) {
    _themeState = state;
    if (state == ThemeState.light) {
      sharedPreferences.setString('theme', 'light');
    } else if (state == ThemeState.dark) {
      sharedPreferences.setString('theme', 'dark');
    }
    notifyListeners();
  }
}
