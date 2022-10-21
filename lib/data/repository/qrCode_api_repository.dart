import 'dart:convert';

import 'package:flutter_desctop/core/extensions.dart';
import 'package:flutter_desctop/main.dart';
import 'package:logger/logger.dart';

class QrCodeApiRepository {
  Future<dynamic> qrStart(Map<String, dynamic> body) async {
    try {
      String t = "/api/v1/auth/qr/start";
      var response = await sessionApi.generalRequest(
        url: t,
        body: body,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      }
      response.statusCode.toString().showCustomToast();
      return null;
    } catch (e) {
      Logger().e(e.toString());
      e.toString().showCustomToast();
      return null;
    }
  }
}
