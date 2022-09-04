import 'package:flutter/material.dart';

import '../../view/main/home/home_view.dart';
import '../../view/main/profile/profile_view.dart';
import '../../view/main/subscription/subscription_view.dart';

class MainProvider extends ChangeNotifier {
  int index = 0;
  Map<String, dynamic> bottomNavBarHover = {
    "index": 0,
    "isHover": false,
  };

  List<Widget> listViews = const [
    HomeView(),
    SubscriptionView(),
    ProfileView(),
  ];

  void updateHoverBottomNavBarItem(int newIndex, bool isHover) {
    bottomNavBarHover["index"] = newIndex;
    bottomNavBarHover["isHover"] = isHover;
    notifyListeners();
  }

  void updateBottomNavBar(int newIndex) {
    index = newIndex;
    notifyListeners();
  }
}
