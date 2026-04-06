import 'package:flutter/material.dart';

class OnBoardingProvider extends ChangeNotifier {
  int currentIndex = 0;

  bool get isLastPage => currentIndex == 2;

  void updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}