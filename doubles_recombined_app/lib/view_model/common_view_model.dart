import 'package:flutter/material.dart';

class CommonViewModel extends ChangeNotifier {
  int index = 0;

  void setCurrentIndex(currentIndex) {
    index = currentIndex;
    notifyListeners();
  }
}