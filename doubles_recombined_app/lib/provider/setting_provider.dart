import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider with ChangeNotifier {
  final SharedPreferences prefs;
  int? _countCourt;

  SettingProvider({
    required this.prefs,
  }) {
    initialize();
  }

  // getter
  int? get countCourt => _countCourt;

  // setter
  set countCourt(countCourt) {
    _countCourt = countCourt;
    setCountCourt(countCourt);
  }

  // 初期化
  Future<void> initialize() async {
    _countCourt = await getCountCourt();
    if (_countCourt == null) {
      _countCourt = 1;
    }
    notifyListeners();
  }

  Future<int?> getCountCourt() async {
    _countCourt = await prefs.getInt('count_court');
    return _countCourt;
  }

  Future<void> setCountCourt(newCountCourt) async {
    await prefs.setInt('count_court', newCountCourt);
    notifyListeners();
  }
}