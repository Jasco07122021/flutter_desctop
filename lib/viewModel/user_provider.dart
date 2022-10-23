import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/model/network_model/user_registration_model.dart';

import '../model/network_model/server_list_model.dart';
import '../model/network_model/system_data_model.dart';

class UserProvider extends ChangeNotifier {
  bool isLogged =
      localDB.getString(LocalDBEnum.token.name) == null ? false : true;

  String? _deviceId;
  UserRegister? _user;
  SystemData? _systemData;
  ServerItem? _server;
  String? _locale;

  UserRegister? get user => _user;

  SystemData? get systemData => _systemData;

  String? get deviceId => _deviceId;

  String? get locale => _locale;

  ServerItem? get server => _server;

  set setUser(UserRegister? human) {
    _user = human;
    notifyListeners();
  }

  set setLocale(String locale) {
    _locale = locale;
    notifyListeners();
  }

  set setSystemData(SystemData? data) {
    _systemData = data;
    notifyListeners();
  }

  set setDevice(String? device) {
    _deviceId = device;
    notifyListeners();
  }

  set setLogin(bool value) {
    isLogged = value;
    notifyListeners();
  }

  set setServer(ServerItem value) {
    _server = value;
    notifyListeners();
  }
}

class ShowAlertProvider with ChangeNotifier {
  bool _isVisible = false;
  String? _error;

  bool get isVisible => _isVisible;

  String? get error => _error;

  set setVisible(bool isVisible) {
    _isVisible = isVisible;
    notifyListeners();
  }

  set setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
