class DistanceModel {
  String? shopName;
  double? distance;
  String? phone;

  DistanceModel({
    this.shopName,
    this.distance,
    this.phone,
  });

  DistanceModel.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    distance = json['distance'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shopName'] = shopName;
    data['distance'] = distance;
    data['phone'] = phone;
    return data;
  }
}
