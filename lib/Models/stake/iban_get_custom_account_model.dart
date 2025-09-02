// To parse this JSON data, do
//
//     final ibanGetCustomAccountsModel = ibanGetCustomAccountsModelFromJson(jsonString);

import 'dart:convert';

IbanGetCustomAccountsModel ibanGetCustomAccountsModelFromJson(String str) => IbanGetCustomAccountsModel.fromJson(json.decode(str));

String ibanGetCustomAccountsModelToJson(IbanGetCustomAccountsModel data) => json.encode(data.toJson());

class IbanGetCustomAccountsModel {
  final int? status;
  final String? message;
  final List<Ibaninfo>? ibaninfo;

  IbanGetCustomAccountsModel({
    this.status,
    this.message,
    this.ibaninfo,
  });

  factory IbanGetCustomAccountsModel.fromJson(Map<String, dynamic> json) => IbanGetCustomAccountsModel(
    status: json["status"],
    message: json["message"],
    ibaninfo: json["ibaninfo"] == null ? [] : List<Ibaninfo>.from(json["ibaninfo"]!.map((x) => Ibaninfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "ibaninfo": ibaninfo == null ? [] : List<dynamic>.from(ibaninfo!.map((x) => x.toJson())),
  };
}

class Ibaninfo {
  final dynamic coinPrice;
  final String? ibanId;
  final String? label;
  final String? currency;
  final String? balance;
  final String? iban;
  final String? currencyflag;

  Ibaninfo({
    this.coinPrice,
    this.ibanId,
    this.label,
    this.currency,
    this.balance,
    this.iban,
    this.currencyflag,
  });

  factory Ibaninfo.fromJson(Map<String, dynamic> json) => Ibaninfo(
    coinPrice: json["coinPrice"],
    ibanId: json["iban_id"],
    label: json["label"],
    currency: json["currency"],
    balance: json["balance"],
    iban: json["iban"],
    currencyflag: json["currencyflag"],
  );

  Map<String, dynamic> toJson() => {
    "coinPrice": coinPrice,
    "iban_id": ibanId,
    "label": label,
    "currency": currency,
    "balance": balance,
    "iban": iban,
    "currencyflag": currencyflag,
  };
}
