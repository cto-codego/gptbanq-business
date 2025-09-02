class Tokennetworks {
  int ?status;
  List<UserAddresses> ?userAddresses;

  Tokennetworks({this.status, this.userAddresses});

  Tokennetworks.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['user_addresses'] != null) {
      userAddresses =   <UserAddresses> [];
      json['user_addresses'].forEach((v) {
        userAddresses!.add(new UserAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userAddresses != null) {
      data['user_addresses'] =
          this.userAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddresses {
  String ?address;
  String ?currencyName;
  String ?network;
  String ?qrcode;

  UserAddresses({this.address, this.currencyName, this.network, this.qrcode});

  UserAddresses.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    currencyName = json['currency_name'];
    network = json['network'];
    qrcode = json['qrcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['currency_name'] = this.currencyName;
    data['network'] = this.network;
    data['qrcode'] = this.qrcode;
    return data;
  }
}