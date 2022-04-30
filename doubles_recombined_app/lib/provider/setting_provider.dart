import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider with ChangeNotifier {
  final SharedPreferences prefs;
  int? _countCourt = 0;
  int? _useCourt = 0;

  SettingProvider({
    required this.prefs,
  }) {
    initialize();
  }

  // getter
  int? get countCourt => _countCourt;
  int? get useCourt => _useCourt;

  // setter
  set countCourt(countCourt) {
    _countCourt = countCourt;
    setCountCourt(countCourt);
  }

  set useCourt(useCourt) {
    _useCourt = useCourt;
    notifyListeners();
  }

  // 初期化
  Future<void> initialize() async {
    _countCourt = await getCountCourt();
    if (_countCourt == null || _countCourt == 0) {
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

  void getUseCourt(gamePlayers) {
    _useCourt = _countCourt!;
    if(_countCourt! * 4 > gamePlayers) {
      _useCourt = gamePlayers ~/ 4;
    }
    notifyListeners();
  }
}