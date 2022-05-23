import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class UserProvider with ChangeNotifier {
  final Database database;
  late List<User> userList = [];
  late List<User> participantUserList = [];
  late List<User> gamePlayUserList = []; // 試合中のユーザーリスト
  late List<User> gameStandUserList = []; // 休憩中のユーザーリスト

  UserProvider({
    required this.database,
  }) {
    initialize();
  }

  // 初期化
  Future<void> initialize() async {
    userList = await getUserList();
    participantUserList = userList.where((User user) => user.status != 0).toList();
    userListsSortByName();
  }

  // 名前(ふりがな)順でソート
  List<User> sortByName(List<User> targetList) {
    targetList.sort((a, b){ 
      return a.name_kana!.toLowerCase().compareTo(b.name_kana!.toLowerCase());
    });
    return targetList;
  }

  // ユーザーリストのソート
  void userListsSortByName() {
    sortByName(userList);
    sortByName(participantUserList);
    notifyListeners();
  }

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

  // ユーザーリストの取得
  Future<List<User>> getUserList() async {
    final List<Map<String, dynamic>> maps = await database.query('users');
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

  // Userデータの追加
  Future<void> addUser(User user) async {
    // データベースに追加
    await database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // userListに追加
    userList = await getUserList(); // IDを取得するためDBから再取得
    syncParticipantUserList();
    userListsSortByName();
    notifyListeners();
  }

  // Userデータの更新
  Future<void> updateUser(User newUser) async {
    // データベースを更新
    await database.update(
      'users',
      newUser.toMap(),
      where: 'id = ?',
      whereArgs: [newUser.id],
    );

    // userListを更新
    userList = await getUserList(); // DBから再取得
    final index = userList.indexWhere((user) => user.id == newUser.id);
    userList[index] = newUser;
    syncParticipantUserList();
    userListsSortByName();

    notifyListeners();
  }

  // Userデータの削除
  Future<void> deleteUser(int userId) async {
    // userListの削除
    final index = userList.indexWhere((user) => user.id == userId);
    userList.removeAt(index);
    syncParticipantUserList();
    userListsSortByName();

    // データベースの削除
    await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    notifyListeners();
  }
}