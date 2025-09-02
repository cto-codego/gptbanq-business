// To parse this JSON data, do
//
//     final swiftSendMoneyUserModel = swiftSendMoneyUserModelFromJson(jsonString);

import 'dart:convert';

SwiftSendMoneyUserModel swiftSendMoneyUserModelFromJson(String str) => SwiftSendMoneyUserModel.fromJson(json.decode(str));

String swiftSendMoneyUserModelToJson(SwiftSendMoneyUserModel data) => json.encode(data.toJson());

class SwiftSendMoneyUserModel {
  int? status;
  List<Pc>? pc;
  String? country;

  SwiftSendMoneyUserModel({
    this.status,
    this.pc,
    this.country,
  });

  factory SwiftSendMoneyUserModel.fromJson(Map<String, dynamic> json) => SwiftSendMoneyUserModel(
    status: json["status"],
    pc: json["pc"] == null ? [] : List<Pc>.from(json["pc"]!.map((x) => Pc.fromJson(x))),
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "pc": pc == null ? [] : List<dynamic>.from(pc!.map((x) => x.toJson())),
    "country": country,
  };
}

class Pc {
  String? id;
  String? countryCode;
  String? paymentCode;
  String? paymentDescription;

  Pc({
    this.id,
    this.countryCode,
    this.paymentCode,
    this.paymentDescription,
  });

  factory Pc.fromJson(Map<String, dynamic> json) => Pc(
    id: json["id"],
    countryCode: json["country_code"],
    paymentCode: json["payment_code"],
    paymentDescription: json["payment_description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_code": countryCode,
    "payment_code": paymentCode,
    "payment_description": paymentDescription,
  };
}
