import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/model/network_model/tariff_list_model.dart';


class SubscriptionProvider extends ChangeNotifier {
  TextEditingController promoCodeController = TextEditingController();
  List<TariffItem> tariffs = [];
  bool isLoading = false;
  bool isHover = false;

  SubscriptionProvider(bool isInit) {
    if (isInit) getTariffList();
  }

  Future<void> getTariffList() async {
    isLoading = true;
    notifyListeners();
    final response = await tariffApi.getTariffList(false);
    if (response != null) {
      tariffs = response;
      notifyListeners();
    } else {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> clickBankCard(String email, String tariffId) async {
    Map<String, dynamic> body = {
      "email": email,
      "promo": promoCodeController.text.trim(),
      "tariffId": tariffId
    };
    String? url = await billingApi.paymentUrl(body);
    if (url != null) {
      url.launchWeb();
    }
  }

  void updateHover(bool value) {
    isHover = value;
    notifyListeners();
  }

  bool checkUser() {
    String? token = localDB.getString(LocalDBEnum.token.name);
    return token != null;
  }
}
