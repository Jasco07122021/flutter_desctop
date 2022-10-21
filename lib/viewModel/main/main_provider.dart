import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/main.dart';
import 'package:logger/logger.dart';

import '../../view/main/home/home_view.dart';
import '../../view/main/profile/profile_view.dart';
import '../../view/main/subscription/subscription_view.dart';

class MainProvider extends ChangeNotifier {
  PageController pageController = PageController(
      initialPage: localDB.getString(LocalDBEnum.token.name) == null ? 2 : 0);
  int index = localDB.getString(LocalDBEnum.token.name) == null ? 2 : 0;
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
    pageController.jumpToPage(index);
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
