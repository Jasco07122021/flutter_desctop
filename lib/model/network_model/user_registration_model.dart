class UserRegister {
  late final String id;
  late final String email;
  late final String promocode;
  late final int uploaded;
  late final int downloaded;
  late final double balance;
  late final int personalPromocodeDiscount;
  late final int boughtByPromocode;
  late final int boughtByPromocodeSum;
  late final int boughtByPromocodeEarned;
  late final String type;
  late final bool primaryReferral;
  late final String createdAt;
  late final int personalPromocodeOwnerBallEarn;

  UserRegister({
    required this.id,
    required this.email,
    required this.promocode,
    required this.uploaded,
    required this.downloaded,
    required this.balance,
    required this.personalPromocodeDiscount,
    required this.boughtByPromocode,
    required this.boughtByPromocodeSum,
    required this.boughtByPromocodeEarned,
    required this.type,
    required this.primaryReferral,
    required this.createdAt,
    required this.personalPromocodeOwnerBallEarn,
  });

  UserRegister.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    promocode = json['promocode'];
    uploaded = json['uploaded'];
    downloaded = json['downloaded'];
    balance = json['balance'];
    personalPromocodeDiscount = json['personalPromocodeDiscount'];
    boughtByPromocode = json['boughtByPromocode'];
    boughtByPromocodeSum = json['boughtByPromocodeSum'];
    boughtByPromocodeEarned = json['boughtByPromocodeEarned'];
    type = json['type'];
    primaryReferral = json['primaryReferral'];
    createdAt = json['createdAt'];
    personalPromocodeOwnerBallEarn = json['personalPromocodeOwnerBallEarn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['promocode'] = promocode;
    data['uploaded'] = uploaded;
    data['downloaded'] = downloaded;
    data['balance'] = balance;
    data['personalPromocodeDiscount'] = personalPromocodeDiscount;
    data['boughtByPromocode'] = boughtByPromocode;
    data['boughtByPromocodeSum'] = boughtByPromocodeSum;
    data['boughtByPromocodeEarned'] = boughtByPromocodeEarned;
    data['type'] = type;
    data['primaryReferral'] = primaryReferral;
    data['createdAt'] = createdAt;
    data['personalPromocodeOwnerBallEarn'] = personalPromocodeOwnerBallEarn;
    return data;
  }
}
