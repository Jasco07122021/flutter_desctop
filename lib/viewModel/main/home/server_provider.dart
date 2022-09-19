import 'package:flutter/material.dart';
import 'package:flutter_desctop/main.dart';

import '../../../model/network_model/server_list_model.dart';

class ServerProvider extends ChangeNotifier {
  int switchedItemIndex = -1;
  int hoverIndex = -1;
  bool isLoading = false;

  List<ServerItem> servers = [];

  ServerProvider() {
    getServerList();
  }

  Future getServerList() async {
    isLoading = true;
    notifyListeners();
    final response = await serverApi.getServerList();
    if (response != null) {
      servers = response;
      notifyListeners();
    } else {}
    isLoading = false;
    notifyListeners();
  }

  void updateHover(int index) {
    hoverIndex = index;
    notifyListeners();
  }

  void updateSwitch(int index) {
    switchedItemIndex = index;
    notifyListeners();
  }
}
