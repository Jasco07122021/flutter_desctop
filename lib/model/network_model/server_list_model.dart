// To parse this JSON data, do
//
//     final serverList = serverListFromJson(jsonString);

import 'dart:convert';

List<ServerItem> serverListFromJson(String str) =>
    List<ServerItem>.from(json.decode(str).map((x) => ServerItem.fromJson(x)));

String serverListToJson(List<ServerItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServerItem {
  ServerItem({
    required this.id,
    required this.country,
    this.countryCode,
    required this.city,
    required this.address,
    required this.certificateFile,
  });

  final String id;
  final String country;
  final String? countryCode;
  final String city;
  final String address;
  final String certificateFile;

  factory ServerItem.fromJson(Map<String, dynamic> json) => ServerItem(
        id: json["id"],
        country: json["country"],
        countryCode: json["countryCode"],
        city: json["city"],
        address: json["address"],
        certificateFile: json["certificateFile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "countryCode": countryCode,
        "city": city,
        "address": address,
        "certificateFile": certificateFile,
      };
}
