import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLogedIn = false;

  bool get isLogedIn {
    return _isLogedIn;
  }

  void changeLoginStatus(bool status, bool notifylisteners) {
    _isLogedIn = status;
    if (notifylisteners) {
      notifyListeners();
    }
  }
}
