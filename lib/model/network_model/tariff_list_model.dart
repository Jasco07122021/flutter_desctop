// To parse this JSON data, do
//
//     final tariffItem = tariffItemFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

List<TariffItem> tariffItemFromJson(Uint8List str) => List<TariffItem>.from(
    json.decode(utf8.decode(str)).map((x) => TariffItem.fromJson(x)));

String tariffItemToJson(List<TariffItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TariffItem {
  TariffItem({
    required this.id,
    required this.name,
    required this.durationType,
    required this.duration,
    required this.bonus,
    required this.locale,
    required this.ruPrice,
    required this.enPrice,
    required this.chPrice,
    required this.discount,
    required this.ballCost,
  });

  final String id;
  final String name;
  final String durationType;
  final int duration;
  final bool bonus;
  final String locale;
  final double ruPrice;
  final double enPrice;
  final double chPrice;
  final int? discount;
  final int ballCost;

  factory TariffItem.fromJson(Map<String, dynamic> json) => TariffItem(
        id: json["id"],
        name: json["name"],
        durationType: json["durationType"],
        duration: json["duration"],
        bonus: json["bonus"],
        locale: json["locale"],
        ruPrice: json["ruPrice"].toDouble(),
        enPrice: json["enPrice"].toDouble(),
        chPrice: json["chPrice"].toDouble(),
        discount: json["discount"],
        ballCost: json["ballCost"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "durationType": durationType,
        "duration": duration,
        "bonus": bonus,
        "locale": locale,
        "ruPrice": ruPrice,
        "enPrice": enPrice,
        "chPrice": chPrice,
        "discount": discount,
        "ballCost": ballCost,
      };
}
