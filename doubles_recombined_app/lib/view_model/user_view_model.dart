import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  late User _user;
  String _sexValue = '未選択';
  bool _participantFlag = false;

  // constructor
  UserViewModel() {
}

  // getter
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

}