import 'package:flutter/material.dart';

class ServerProvider extends ChangeNotifier {
  bool switcherServer = false;

  void updateSwitch(bool value, [updateValue = false]) {
    if (updateValue) {
      switcherServer = !switcherServer;
    } else {
      switcherServer = value;
    }
    notifyListeners();
  }
}
