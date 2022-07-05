class ShopModel {
  String? email;
  String? shopName;
  String? shopOwner;
  String? shopPhone;
  String? open;
  String? close;
  String? uid;
  String? role;
  bool? approve;
  double? latitude;
  double? longitude;

  ShopModel({
    this.email,
    this.shopName,
    this.shopOwner,
    this.shopPhone,
    this.open,
    this.close,
    this.latitude,
    this.longitude,
    this.uid,
    this.role,
    this.approve,
  });

  ShopModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    shopName = json['shopName'];
    shopOwner = json['shopOwner'];
    shopPhone = json['shopPhone'];
    open = json['open'];
    close = json['close'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    uid = json['uid'];
    role = json['role'];
    approve = json['approve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['shopName'] = shopName;
    data['shopOwner'] = shopOwner;
    data['shopPhone'] = shopPhone;
    data['open'] = open;
    data['close'] = close;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['uid'] = uid;
    data['role'] = role;
    data['approve'] = approve;
    return data;
  }
}
