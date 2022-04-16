import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class ParticipantViewModel extends ChangeNotifier {
  late User _user;

  // constructor
  ParticipantViewModel() {
  }

  // getter
  User get user => _user;

  // setter
  set user(User inputUser) {
    _user = inputUser;
    notifyListeners();
  }

}