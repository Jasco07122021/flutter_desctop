import 'dart:typed_data';

import 'package:flutter_desctop/model/network_model/system_data_model.dart';
import 'package:logger/logger.dart';

import '../../main.dart';

class SystemApiRepository {
  Future<SystemData?> getSystem() async {
    try {
      String t = "/api/v1/system/";
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: {},
      );
      if (response.statusCode == 200) {
        final SystemData result = systemDataFromJson(response.body);
        return result;
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }

  Future<Uint8List?> getImage() async {
    try {
      String t = "/api/v1/system/ad-image";
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: {},
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }
}
