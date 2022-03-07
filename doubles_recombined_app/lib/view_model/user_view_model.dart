import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  late List<User> _users = [];

  UserViewModel() {
    _init();
  }

  List<User> get users => _users;

  void _init() async {
    _users = await User.getUsers();
    notifyListeners();
  }

  void syncDb() async {
    User.getUsers().then(
      (val) => _users
        ..clear()
        ..addAll(val),
    );
    notifyListeners();
  }

  // データの追加
  void add(User user) async {
    await User.insertUser(user);
    syncDb();
  }

  // データの削除
  void delete(int id) async {
    await User.deleteUser(id);
    syncDb();
  }

  // データの更新
  void edit(User user) async {
    await User.updateUser(user);
    notifyListeners();
  }

}