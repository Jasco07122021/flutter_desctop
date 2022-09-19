import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/model/network_model/user_registration_model.dart';

import '../../../model/network_model/tariff_list_model.dart';

class ReferallSystemProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isFull = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController bankingDetailsController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<TariffItem> tariffBonuses = [];
  List<Map<String, dynamic>> list = [];

  ReferallSystemProvider() {
    initState();
  }

  Future<void> initState() async {
    isLoading = true;
    notifyListeners();
    final response = await tariffApi.getTariffList(true);
    if (response != null) {
      tariffBonuses = response;
      notifyListeners();
    } else {}
    isLoading = false;
    notifyListeners();
  }

  Future<UserRegister?> getBonus(String id) async {
    String token = localDB.getString(LocalDBEnum.token.name)!;
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> body = {"tariffId": id};
    final response = await subscriptionApi.buyBalance(body);
    if (response != null) {
      UserRegister? user = await userApi.getUserMe(token);
      isLoading = false;
      notifyListeners();
      return user;
    } else {
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<UserRegister?> sendQuestion(int balance) async {
    String email = emailController.text;
    String price = priceController.text;
    String card = bankingDetailsController.text;
    int? priceInt = int.tryParse(price);
    if (card.isEmpty) {
      "Введите реквизиты".showCustomToast();
      return null;
    } else if (price.isEmpty ||
        priceInt == null ||
        priceInt == 0 ||
        priceInt > balance) {
      "Неверная сумма".showCustomToast();
      return null;
    }
    Map<String, dynamic> body = {
      "count": priceInt,
      "email": email,
      "card": card
    };
    String token = localDB.getString(LocalDBEnum.token.name)!;
    isLoading = true;
    notifyListeners();

    final response = await userApi.withdrawPost(body: body);

    if (response != null) {
      UserRegister? user = await userApi.getUserMe(token);
      isLoading = false;
      notifyListeners();
      return user;
    } else {
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  List<Map<String, dynamic>> updateList(String email) {
    list.addAll([
      {
        "Email": emailController..text = email,
        "hintText": "example@gmail.com",
      },
      {
        "Реквизиты": bankingDetailsController,
        "hintText": "",
      },
      {
        "Сумма": priceController,
        "hintText": "150\$",
      },
    ]);
    return list;
  }

  void clear() {
    emailController.clear();
    priceController.clear();
    bankingDetailsController.clear();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}
