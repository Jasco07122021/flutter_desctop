// To parse this JSON data, do
//
//     final historyQuestionItem = historyQuestionItemFromJson(jsonString);

import 'dart:convert';

HistoryQuestionItem historyQuestionItemFromJson(String str) =>
    HistoryQuestionItem.fromJson(json.decode(str));

String historyQuestionItemToJson(HistoryQuestionItem data) =>
    json.encode(data.toJson());

class HistoryQuestionItem {
  HistoryQuestionItem({
    required this.data,
    required this.totalElements,
    required this.pageCount,
    required this.page,
  });

  final List<Datum> data;
  final int totalElements;
  final int pageCount;
  final int page;

  factory HistoryQuestionItem.fromJson(Map<String, dynamic> json) =>
      HistoryQuestionItem(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalElements: json["totalElements"],
        pageCount: json["pageCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalElements": totalElements,
        "pageCount": pageCount,
        "page": page,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.email,
    required this.card,
    required this.count,
    required this.state,
  });

  final String id;
  final String email;
  final String card;
  final double count;
  final String state;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        email: json["email"],
        card: json["card"],
        count: json["count"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "card": card,
        "count": count,
        "state": state,
      };
}
