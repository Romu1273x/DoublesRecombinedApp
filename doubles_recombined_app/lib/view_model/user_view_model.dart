import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  late List<User> _users = [];
  late User _user;
  String _sexValue = '未選択';
  bool _participantFlag = false;

  // constructor
  UserViewModel() {
    _init();
  }

  // getter
  List<User> get users => _users;
  User get user => _user;
  String get sexValue => _sexValue;
  bool get participantFlag => _participantFlag;

  // setter
  set user(User inputUser) {
    _user = inputUser;
    notifyListeners();
  }

  set sexValue(String inputSexValue) {
    _sexValue = inputSexValue;
    notifyListeners();
  }

  set participantFlag(bool inputParticipantFlag) {
    _participantFlag = inputParticipantFlag;
    notifyListeners();
  }

  // 初期化処理
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

  // ユーザー情報入力ダイアログの初期値の設定
  void initUser() {
    // 新規ユーザー登録の場合
    _sexValue = '未選択';
    _participantFlag = false;

    // ユーザー編集の場合
    if (_user.name != null) {
      if (_user.sex == 1) {
        _sexValue = '男性';
      } else {
        _sexValue = '女性';
      }

      if (_user.participant == 0) {
        _participantFlag = true;
      } else {
        _participantFlag = false;
      }
    }
  }

  // ユーザーリストの追加
  void addUserList() async {
    add(_user);
  }

  // ユーザーリストの編集
  void editUserList() async {
    edit(_user);
  }

}