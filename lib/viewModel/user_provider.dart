import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool isLogged = false;

  bool get logging => isLogged;

  set setLogin(bool value) {
    isLogged = value;
    notifyListeners();
  }
}
