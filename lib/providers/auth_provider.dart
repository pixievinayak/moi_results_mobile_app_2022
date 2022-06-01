import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier{

  bool _isUserLoggedIn = false;

  bool getIsUserLoggedIn() => _isUserLoggedIn;
  setIsUserLoggedIn(bool value){
    if(_isUserLoggedIn != value){
      _isUserLoggedIn = value;
      notifyListeners();
    }
  }
}