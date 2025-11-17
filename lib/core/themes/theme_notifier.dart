import 'package:flutter/material.dart';
import 'app_theme.dart';

//okay está bugado mas eu estou com sono
class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeData get currentTheme =>
      _isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme(bool value) {
    _isDark = value;
    notifyListeners();
  }
}
