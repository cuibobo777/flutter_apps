import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // 初始化浅色主题

  ThemeData _themeData = lightMode;

  // 获取当前主题
  ThemeData get themeData => _themeData;

  // 如果当前是深色主题
  bool get isDarkMode => _themeData == darkMode;

  // 设置主题
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // 切换主题
  void toggleTheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}
