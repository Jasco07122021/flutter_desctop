import 'dart:developer';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';

class HomeProvider extends ChangeNotifier {
  double rating = 0.0;
  bool isLoading = false;
  bool isConnected = false;

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
