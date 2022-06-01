import 'package:flutter/foundation.dart';

class BottomNavBarProvider with ChangeNotifier {
  int _currentIndex;

  BottomNavBarProvider({int initialIndex = 0})
    : _currentIndex = initialIndex;

  int getCurrentIndex() => _currentIndex;

  setCurrentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}