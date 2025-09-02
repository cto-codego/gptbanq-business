// To parse this JSON data, do
//
//     final cryptoGatewayCurrencyListModel = cryptoGatewayCurrencyListModelFromJson(jsonString);

import 'dart:convert';

CryptoGatewayCurrencyListModel cryptoGatewayCurrencyListModelFromJson(
        String str) =>
    CryptoGatewayCurrencyListModel.fromJson(json.decode(str));

String cryptoGatewayCurrencyListModelToJson(
        CryptoGatewayCurrencyListModel data) =>
    json.encode(data.toJson());

class CryptoGatewayCurrencyListModel {
  final int? status;
  String? message;
  final List<CryptoGatewayCurrency>? currency;

  CryptoGatewayCurrencyListModel({
    this.status,
    this.message,
    this.currency,
  });

  factory CryptoGatewayCurrencyListModel.fromJson(Map<String, dynamic> json) =>
      CryptoGatewayCurrencyListModel(
        status: json["status"],
        message: json["message"],
        currency: json["currency"] == null
            ? []
            : List<CryptoGatewayCurrency>.from(json["currency"]!
                .map((x) => CryptoGatewayCurrency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "currency": currency == null
            ? []
            : List<dynamic>.from(currency!.map((x) => x.toJson())),
      };
}

class CryptoGatewayCurrency {
  final String? currency;
  final String? flag;

  CryptoGatewayCurrency({
    this.currency,
    this.flag,
  });

  factory CryptoGatewayCurrency.fromJson(Map<String, dynamic> json) =>
      CryptoGatewayCurrency(
        currency: json["currency"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "flag": flag,
      };
}
