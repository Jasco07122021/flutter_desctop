import 'dart:io';

import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  double rating = 0.0;
  bool isLoading = false;
  bool isConnected = false;
  bool isHoverCity = false;
  bool isHoverPowerButton = false;

  bool openServerView = false;

  void updateNavigator(bool value){
    openServerView = value;
    notifyListeners();
  }

  void updateHoverCityOrPowerButton(bool isHovered, bool isCity) {
    if (isCity) {
      isHoverCity = isHovered;
    } else {
      isHoverPowerButton = isHovered;
    }
    notifyListeners();
  }

  void updateRating(double value) {
    rating = value;
    notifyListeners();
  }

  Future<void> onPressPower() async {
    isLoading = true;
    notifyListeners();

    String request =
        !isConnected ? "rasdial aaaaa" : "rasdial aaaaa /disconnect";

    final result = await Process.run('powershell.exe', [request]);

    if (result.exitCode == 0) {
      isConnected = !isConnected;
    } else {
      isConnected = false;
    }

    isLoading = false;
    notifyListeners();
  }
}
