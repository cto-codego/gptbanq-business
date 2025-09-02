// To parse this JSON data, do
//
//     final ibanGetCustomAccountsModel = ibanGetCustomAccountsModelFromJson(jsonString);

import 'dart:convert';

CdgAccountsModel cdgAccountsModelFromJson(String str) =>
    CdgAccountsModel.fromJson(json.decode(str));

String cdgAccountsModelToJson(CdgAccountsModel data) =>
    json.encode(data.toJson());

class CdgAccountsModel {
  final int? status;
  final String? message;
  final List<CdgIbaninfo>? cdgIbanInfo;

  CdgAccountsModel({
    this.status,
    this.message,
    this.cdgIbanInfo,
  });

  factory CdgAccountsModel.fromJson(Map<String, dynamic> json) =>
      CdgAccountsModel(
        status: json["status"],
        message: json["message"],
        cdgIbanInfo: json["ibaninfo"] == null
            ? []
            : List<CdgIbaninfo>.from(
                json["ibaninfo"]!.map((x) => CdgIbaninfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "ibaninfo": cdgIbanInfo == null
            ? []
            : List<dynamic>.from(cdgIbanInfo!.map((x) => x.toJson())),
      };
}

class CdgIbaninfo {
  final dynamic coinPrice;
  final String? ibanId;
  final String? label;
  final String? currency;
  final String? balance;
  final String? iban;
  final String? currencyflag;
  final String? availableBalance;
  final String? showlabel;

  CdgIbaninfo({
    this.coinPrice,
    this.ibanId,
    this.label,
    this.currency,
    this.balance,
    this.iban,
    this.currencyflag,
    this.availableBalance,
    this.showlabel,
  });

  factory CdgIbaninfo.fromJson(Map<String, dynamic> json) => CdgIbaninfo(
        coinPrice: json["coinPrice"],
        ibanId: json["iban_id"],
        label: json["label"],
        currency: json["currency"],
        balance: json["balance"],
        iban: json["iban"],
        currencyflag: json["currencyflag"],
        availableBalance: json["availableBalance"],
        showlabel: json["showlabel"],
      );

  Map<String, dynamic> toJson() => {
        "coinPrice": coinPrice,
        "iban_id": ibanId,
        "label": label,
        "currency": currency,
        "balance": balance,
        "iban": iban,
        "currencyflag": currencyflag,
        "availableBalance": availableBalance,
        "showlabel": showlabel,
      };
}
