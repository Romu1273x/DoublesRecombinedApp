import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:doubles_recombined_app/model/setting_model.dart';

class SettingProvider with ChangeNotifier {
  final Database database;
  late List<Setting> settingList;

  SettingProvider({
    required this.database,
    this.settingList = const [],
  }) {
    initialize();
  }

  // 初期化
  Future<void> initialize() async {
    if (settingList.length == 0) {
      Setting setting = Setting(count_court: 1);
      addSetting(setting);
    }
    settingList = await getSettingList();
  }

  // Settingリストの取得(リストは１つだけ)
  Future<List<Setting>> getSettingList() async {
    final List<Map<String, dynamic>> maps = await database.query('setting');
    return List.generate(maps.length, (i) {
      return Setting(
        id: maps[i]['id'],
        count_court: maps[i]['count_court'],
      );
    });
  }

  // Settingデータの追加
  Future<void> addSetting(Setting setting) async {
    // データベースに追加
    await database.insert(
      'setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  // Settingデータの更新
  Future<void> updateSetting(Setting newSetting) async {
    // データベースを更新
    await database.update(
      'setting',
      newSetting.toMap(),
      where: 'id = ?',
      whereArgs: [newSetting.id],
    );
    notifyListeners();
  }

  // Settingデータの削除
  Future<void> deleteSetting(int settingId) async {
    // データベースの削除
    await database.delete(
      'setting',
      where: 'id = ?',
      whereArgs: [settingId],
    );
    notifyListeners();
  }
}