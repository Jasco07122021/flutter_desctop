import 'dart:convert';

import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/model/network_model/history_question_model.dart';
import 'package:flutter_desctop/model/network_model/user_registration_model.dart';
import 'package:logger/logger.dart';

class UserApiRepository {
  Future<UserRegister?> getUserMe(String token) async {
    try {
      sessionApi.setToken(token: token);
      String t = "/api/v1/user/me";
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: {},
      );
      final data = jsonDecode(response.body);
      localDB.setString(LocalDBEnum.result.name, response.body);
      if (response.statusCode == 200) {
        final UserRegister result = UserRegister.fromJson(data);
        return result;
      }
      return null;
    } catch (ex) {
      Logger().e(ex.toString());
      return null;
    }
  }

  Future<String?> postAnonymous(String deviceId) async {
    try {
      String t = "/api/v1/user/anonymous";
      var response =
          await sessionApi.generalRequest(url: t, body: {"deviceId": deviceId});
      if (response.statusCode == 200) {
        return deviceId;
      }
      return null;
    } catch (ex) {
      Logger().e(ex.toString());
      return null;
    }
  }

  Future withdrawPost({
    required Map<String, dynamic> body,
  }) async {
    try {
      String t = "/api/v1/user/withdraw";

      var response = await sessionApi.generalRequest(url: t, body: body);

      final data = jsonDecode(response.body);
      Logger().i(data.toString());
      if (response.statusCode == 200) {
        return true;
      }
      return null;
    } catch (ex) {
      Logger().e(ex.toString());
      return null;
    }
  }

  Future<List<Datum>?> withdrawGet({
    required Map<String, dynamic> queryParameters,
    required String token,
  }) async {
    try {
      String t = "/api/v1/user/withdraw";
      sessionApi.setToken(token: token);
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: queryParameters,
      );
      sessionApi.removeToken();
      Logger().i(response.body.toString());
      if (response.statusCode == 200) {
        return historyQuestionItemFromJson(response.body).data;
      }
      return null;
    } catch (ex) {
      Logger().e(ex.toString());
      return null;
    }
  }

  Future<bool> deleteUser(String token) async {
    try {
      sessionApi.setToken(token: token);
      String t = "/api/v1/user/";
      var response = await sessionApi.generalRequestDelete(url: t);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (ex) {
      Logger().e(ex.toString());
      return false;
    }
  }
}
