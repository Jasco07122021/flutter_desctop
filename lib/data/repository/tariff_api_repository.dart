import 'package:flutter_desctop/model/network_model/tariff_list_model.dart';
import 'package:logger/logger.dart';

import '../../main.dart';

class TariffApiRepository {
  Future<List<TariffItem>?> getTariffList(bool isBonus) async {
    try {
      String t = isBonus ? "/api/v2/tariff/bonus" : "/api/v2/tariff/";
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return tariffItemFromJson(response.bodyBytes);
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }
}
