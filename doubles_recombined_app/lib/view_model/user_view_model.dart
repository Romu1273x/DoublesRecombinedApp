import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  late List<User> _users = [];
  late String _name;
  late String _name_kana;
  late int _sex;
  late int _participant;

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

  // 名前を変更
  void onNameChange(String name) {
    _name = name;
    notifyListeners();
  }

  // 名前(かな)を変更
  void onNameKanaChange(String name_kana) {
    _name_kana = name_kana;
    notifyListeners();
  }

  // 性別を変更
  void onSexChange(int sex) {
    _sex = sex;
    notifyListeners();
  }

  // 参加を変更
  void onParticipantChange(int participant) {
    _participant = participant;
    notifyListeners();
  }

  // ユーザーリストを追加
  void addUserList() async {
    User _user = User(
      name: _name,
      name_kana:  _name_kana,
      sex: _sex,
      participant: _participant 
    );
    add(_user);
  }

}