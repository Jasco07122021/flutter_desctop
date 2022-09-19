// To parse this JSON data, do
//
//     final systemData = systemDataFromJson(jsonString);

import 'dart:convert';

SystemData systemDataFromJson(String str) =>
    SystemData.fromJson(json.decode(str));

String systemDataToJson(SystemData data) => json.encode(data.toJson());

class SystemData {
  SystemData({
    this.appleModeration,
    this.discountType,
    this.discount,
    this.enablePromos,
    this.promocodeOwnerBallEarn,
    this.bannerRedirect,
    this.mainAd,
  });

  bool? appleModeration;
  String? discountType;
  int? discount;
  bool? enablePromos;
  int? promocodeOwnerBallEarn;
  String? bannerRedirect;
  String? mainAd;

  factory SystemData.fromJson(Map<String, dynamic> json) => SystemData(
        appleModeration: json["appleModeration"],
        discountType: json["discountType"],
        discount: json["discount"],
        enablePromos: json["enablePromos"],
        promocodeOwnerBallEarn: json["promocodeOwnerBallEarn"],
        bannerRedirect: json["bannerRedirect"],
        mainAd: json["mainAd"],
      );

  Map<String, dynamic> toJson() => {
        "appleModeration": appleModeration,
        "discountType": discountType,
        "discount": discount,
        "enablePromos": enablePromos,
        "promocodeOwnerBallEarn": promocodeOwnerBallEarn,
        "bannerRedirect": bannerRedirect,
        "mainAd": mainAd,
      };
}
