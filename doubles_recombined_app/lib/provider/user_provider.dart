import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class UserProvider with ChangeNotifier {
  final Database database;
  late List<User> userList;
  late List<User> participantUserList;
  late List<User> gamePlayUserList; // 試合中のユーザーリスト
  late List<User> gameStandUserList; // 休憩中のユーザーリスト

  UserProvider({
    required this.database,
    this.userList = const [],
    this.participantUserList = const [],
    this.gamePlayUserList = const [],
    this.gameStandUserList = const [],
  }) {
    initialize();
  }

  // 初期化
  Future<void> initialize() async {
    userList = await getUserList();
    participantUserList = userList.where((User user) => user.status != 0).toList();
  }

  // ユーザーリストの取得
  Future<List<User>> getUserList() async {
    final List<Map<String, dynamic>> maps = await database.query('user');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        name_kana: maps[i]['name_kana'],
        gender: maps[i]['gender'],
        status: maps[i]['status'],
      );
    });
  }

  // void syncDb() async {
  //   getUserList().then(
  //     (val) => userList
  //       ..clear()
  //       ..addAll(val),
  //   );
  //   notifyListeners();
  // }

  // 参加者リストの更新
  void syncParticipantUserList() {
    participantUserList = userList.where((User user) => user.status != 0).toList();
  }

  // 試合中,休憩中のユーザーリストを取得
  void getGameUserList(int useCourts) {
    int gamePlayers = 4 * useCourts;
    gamePlayUserList = [];
    gameStandUserList = [];

    participantUserList.shuffle();
    if (participantUserList.length >= gamePlayers) {
      for (int i = 0; i < gamePlayers; i++) {
        gamePlayUserList.add(participantUserList[i]);
      }
      for (int i = gamePlayers; i < participantUserList.length; i++) {
        gameStandUserList.add(participantUserList[i]);
      }
    }
    notifyListeners();
  }

  // Userデータの追加
  Future<void> addUser(User user) async {
    // userListに追加
    userList.add(user);
    syncParticipantUserList();

    // データベースに追加
    await database.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  // Userデータの更新
  Future<void> updateUser(User newUser) async {
    // userListを更新
    final index = userList.indexWhere((user) => user.id == newUser.id);
    userList[index] = newUser;
    syncParticipantUserList();

    // データベースを更新
    await database.update(
      'user',
      newUser.toMap(),
      where: 'id = ?',
      whereArgs: [newUser.id],
    );
    notifyListeners();
  }

  // Userデータの削除
  Future<void> deleteUser(int userId) async {
    // userListの削除
    final index = userList.indexWhere((user) => user.id == userId);
    userList.removeAt(index);
    syncParticipantUserList();

    // データベースの削除
    await database.delete(
      'user',
      where: 'id = ?',
      whereArgs: [userId],
    );
    notifyListeners();
  }
}