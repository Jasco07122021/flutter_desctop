// To parse this JSON data, do
//
//     final subscriptionItem = subscriptionItemFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

SubscriptionItem subscriptionItemFromJson(Uint8List str) => SubscriptionItem.fromJson(json.decode(utf8.decode(str)));

String subscriptionItemToJson(SubscriptionItem data) => json.encode(data.toJson());

class SubscriptionItem {
  SubscriptionItem({
   required this.id,
    this.name,
    this.expiredAt,
   required this.permanent,
   required this.robokassa,
  });

  String id;
  String? name;
  String? expiredAt;
  bool permanent;
  bool robokassa;

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) => SubscriptionItem(
    id: json["id"],
    name: json["name"],
    expiredAt: json["expiredAt"],
    permanent: json["permanent"],
    robokassa: json["robokassa"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "expiredAt": expiredAt,
    "permanent": permanent,
    "robokassa": robokassa,
  };
}
