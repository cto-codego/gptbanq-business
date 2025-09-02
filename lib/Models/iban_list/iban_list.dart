// To parse this JSON data, do
//
//     final ibanlistModel = ibanlistModelFromJson(jsonString);

import 'dart:convert';

IbanlistModel ibanlistModelFromJson(String str) =>
    IbanlistModel.fromJson(json.decode(str));

String ibanlistModelToJson(IbanlistModel data) => json.encode(data.toJson());

class IbanlistModel {
  final int? status;
  final List<Ibaninfo>? ibaninfo;

  IbanlistModel({
    this.status,
    this.ibaninfo,
  });

  factory IbanlistModel.fromJson(Map<String, dynamic> json) => IbanlistModel(
        status: json["status"],
        ibaninfo: json["ibaninfo"] == null
            ? []
            : List<Ibaninfo>.from(
                json["ibaninfo"]!.map((x) => Ibaninfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "ibaninfo": ibaninfo == null
            ? []
            : List<dynamic>.from(ibaninfo!.map((x) => x.toJson())),
      };
}

class Ibaninfo {
  final dynamic routingCodeType;
  final String? ibanId;
  final String? label;
  final String? currency;
  final String? balance;
  final String? iban;
  final String? bic;
  final String? currencyflag;
  final String? accountType;
  final String? routing;
  final String? provider;

  Ibaninfo({
    this.routingCodeType,
    this.ibanId,
    this.label,
    this.currency,
    this.balance,
    this.iban,
    this.bic,
    this.currencyflag,
    this.accountType,
    this.routing,
    this.provider,
  });

  factory Ibaninfo.fromJson(Map<String, dynamic> json) => Ibaninfo(
        routingCodeType: json["routing_code_type"],
        ibanId: json["iban_id"],
        label: json["label"],
        currency: json["currency"],
        balance: json["balance"],
        iban: json["iban"],
        bic: json["bic"],
        currencyflag: json["currencyflag"],
        accountType: json["account_type"],
        routing: json["routing"],
        provider: json["provider"],
      );

  Map<String, dynamic> toJson() => {
        "routing_code_type": routingCodeType,
        "iban_id": ibanId,
        "label": label,
        "currency": currency,
        "balance": balance,
        "iban": iban,
        "bic": bic,
        "currencyflag": currencyflag,
        "account_type": accountType,
        "routing": routing,
        "provider": provider,
      };
}
