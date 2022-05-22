import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/utility/validator.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  late User _user;
  String _sexValue = '未選択';
  bool _participantFlag = false;
  String _inputStatus = 'ADD';
  String _title = '新規メンバー登録';

  // constructor
  UserViewModel();

  // getter
  User get user => _user;
  String get sexValue => _sexValue;
  bool get participantFlag => _participantFlag;
  String get inputStatus => _inputStatus;
  String get title => _title;

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

  set inputStatus(String inputStatusValue) {
    _inputStatus = inputStatusValue;
    notifyListeners();
  }

  set title(String inputTitleValue) {
    _title = inputTitleValue;
    notifyListeners();
  }

  // ユーザー情報入力ダイアログの初期値の設定
  void init(User? user) {
    if (user == null) {
      // 新規ユーザー登録の場合
      _user = User(status: 0);
      _sexValue = '未選択';
      _participantFlag = false;
      _inputStatus = 'ADD';
      _title = '新規メンバー登録';
    } else {
      // ユーザー編集の場合
      _user = user;
      _inputStatus = 'EDT';
      _title = 'メンバー情報変更';
      if (user.gender == 1) {
        _sexValue = '男性';
      } else {
        _sexValue = '女性';
      }
      if (user.status == null || user.status == 0) {
        _participantFlag = false;
      } else {
        _participantFlag = true;
      }
    }
  }

  // 入力値のバリデーション
  String validationUser(User user) {
    String? errorMessage;
    List<String> errorMessages = <String>[];
    String errorString = '';

    // 名前
    errorMessage = Validator.NameValidation(user.name);
    if (errorMessage != null) {
      errorMessages.add(errorMessage); 
    }

    // ふりがな
    errorMessage = Validator.NameKanaValidation(user.name_kana);
    if (errorMessage != null) {
      errorMessages.add(errorMessage); 
    }

    // 性別
    if (user.gender == null) {
      errorMessages.add('性別を選択してください');
    } 

    // 参加
    if (user.status == null) {
      errorMessages.add('参加可否を選択してください');
    }

    errorMessages.forEach(
      (value){
        errorString = errorString + value + "\n";
      }
    );
    return errorString;
  }
}
