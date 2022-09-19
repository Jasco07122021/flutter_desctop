import 'dart:convert';

import 'package:flutter_desctop/model/network_model/subscription_model.dart';
import 'package:logger/logger.dart';

import '../../main.dart';

class SubscriptionApiRepository {
  Future<SubscriptionItem?> getSubscription() async {
    try {
      String t = "/api/v1/subscription/";
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: {},
      );
      if (response.statusCode == 200) {
        SubscriptionItem subscriptionItem =
            subscriptionItemFromJson(response.bodyBytes);
        return subscriptionItem;
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }

  Future<dynamic> buyBalance(Map<String, dynamic> body) async {
    try {
      String t = "/api/v1/subscription/buy-by-balance";
      var response = await sessionApi.generalRequest(url: t, body: body);
      final data = jsonDecode(response.body);
      Logger().i(data.toString());
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }
}
