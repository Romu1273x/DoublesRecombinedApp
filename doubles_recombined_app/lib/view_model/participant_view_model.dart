import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class ParticipantViewModel extends ChangeNotifier {
  late List<User> _users = [];
  late User _user;

  // constructor
  ParticipantViewModel() {
    _init();
  }

  // getter
  List<User> get users => _users;
  User get user => _user;

  // setter
  set user(User inputUser) {
    _user = inputUser;
    notifyListeners();
  }

  // 初期化処理
  void _init() async {
    _users = await User.getParticipantUsers();
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

  // データの更新
  void edit(User user) async {
    await User.updateUser(user);
    notifyListeners();
  }

}