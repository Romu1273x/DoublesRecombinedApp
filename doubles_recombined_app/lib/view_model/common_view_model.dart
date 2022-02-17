import 'package:flutter/material.dart';

class CommonViewModel extends ChangeNotifier {
  int _index = 0;

  // Getter
  int get index => _index;

  // Setter
  set index(int currentIndex) {
    _index = currentIndex;
    notifyListeners();
  }
}