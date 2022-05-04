import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider({
    required this.prefs,
  }) {
    _initialize();
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode setMode){
    update(setMode);
  }

  void _initialize() async {
    _themeMode = await loadThemeMode();
    notifyListeners();
  }

  void update(ThemeMode newMode) {
    _themeMode = newMode;
    saveThemeMode(newMode);
    notifyListeners();
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(mode.key, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return toMode(prefs.getString(ThemeMode.system.key) ?? ThemeMode.system.name);
  }

  ThemeMode toMode(String str) {
    return ThemeMode.values.where((val) => val.name == str).first;
  }

  ThemeMode stringToThemMode(String str) {
    switch (str) {
      case 'システムモード':
        return ThemeMode.system;
      case 'ライトモード':
        return ThemeMode.light;
      case 'ダークモード':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String themModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'システムモード';
      case ThemeMode.light:
        return 'ライトモード';
      case ThemeMode.dark:
        return 'ダークモード';
      default:
        return 'システムモード';
    }
  }
}

extension ThemeModeEx on ThemeMode {
  String get key => toString().split('.').first;
  String get name => toString().split('.').last;
}
