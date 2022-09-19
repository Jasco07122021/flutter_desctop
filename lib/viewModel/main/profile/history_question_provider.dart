import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/model/network_model/history_question_model.dart';
import 'package:logger/logger.dart';

class HistoryQuestionProvider extends ChangeNotifier {
  bool isLoading = false;
  bool paginationLoading = false;

  int page = 0;
  int pageSize = 10;

  bool pageLimit = false;

  List<Datum> historyList = [];

  HistoryQuestionProvider() {
    initState();
  }

  Future<void> initState() async {
    isLoading = true;
    notifyListeners();
    String token = localDB.getString(LocalDBEnum.token.name)!;
    Map<String, dynamic> queryParameters = {
      "page": "$page",
      "pageSize": "$pageSize"
    };
    final response = await userApi.withdrawGet(
      queryParameters: queryParameters,
      token: token,
    );
    if (response != null) {
      historyList = response;
    } else {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> getNewList() async {
    if (pageLimit) {
      return;
    } else {
      paginationLoading = true;
      page += 1;
      notifyListeners();

      String token = localDB.getString(LocalDBEnum.token.name)!;
      Map<String, dynamic> queryParameters = {
        "page": "$page",
        "pageSize": "$pageSize"
      };

      final response = await userApi.withdrawGet(
        queryParameters: queryParameters,
        token: token,
      );

      if (response != null) {
        Logger().i(response.toString());
        if (response.isEmpty) {
          pageLimit = true;
          notifyListeners();
        } else {
          List<Datum> list = historyList;
          Logger().i(list.length);
          list.addAll(response);
          Logger().i(list.length);
          historyList = list;
          notifyListeners();
        }
      } else {}
      paginationLoading = false;
      notifyListeners();
    }
  }

  Color getBorder(Datum datum) {
    if (datum.state == "NEW") {
      return const Color(0xFFDA9E00);
    } else if (datum.state == "EXECUTED") {
      return const Color(0xFF00B593);
    } else {
      return const Color(0xFFB50000);
    }
  }

  Color getColor(Datum datum) {
    if (datum.state == "NEW") {
      return const Color.fromRGBO(
        212,
        197,
        9,
        0.14073,
      );
    } else if (datum.state == "EXECUTED") {
      return const Color.fromRGBO(31, 178, 148, 0.161604);
    } else {
      return const Color.fromRGBO(178, 31, 31, 0.161604);
    }
  }
}
