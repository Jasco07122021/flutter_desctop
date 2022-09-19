import 'dart:convert';

import 'package:flutter_desctop/main.dart';
import 'package:logger/logger.dart';

class AuthApiRepository {
  Future<dynamic> google(Map<String, dynamic> body) async {
    try {
      String t = "/api/v1/auth/google";
      var response = await sessionApi.generalRequest(
        url: t,
        body: body,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }

  Future<dynamic> email(Map<String, dynamic> body) async {
    try {
      String t = "/api/v1/auth/email";
      var response = await sessionApi.generalRequest(
        url: t,
        body: body,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }

  Future<dynamic> emailConfirmation(Map<String, dynamic> body,
      [bool isSubmit = false]) async {
    try {
      final String t;
      if (isSubmit) {
        t = "/api/v1/auth/email-confirmation/submit";
      } else {
        t = "/api/v1/auth/email-confirmation/start";
      }
      var response = await sessionApi.generalRequest(
        url: t,
        body: body,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isSubmit && data["state"] == "CONFIRMED") {
          return data["id"];
        }
        return isSubmit ? false : data["id"];
      }
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }
}
