// To parse this JSON data, do
//
//     final cardIbanListModel = cardIbanListModelFromJson(jsonString);

import 'dart:convert';

CardIbanListModel cardIbanListModelFromJson(String str) => CardIbanListModel.fromJson(json.decode(str));

String cardIbanListModelToJson(CardIbanListModel data) => json.encode(data.toJson());

class CardIbanListModel {
  int? status;
  List<Ibaninfo>? ibaninfo;

  CardIbanListModel({
    this.status,
    this.ibaninfo,
  });

  factory CardIbanListModel.fromJson(Map<String, dynamic> json) => CardIbanListModel(
    status: json["status"],
    ibaninfo: json["ibaninfo"] == null ? [] : List<Ibaninfo>.from(json["ibaninfo"]!.map((x) => Ibaninfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "ibaninfo": ibaninfo == null ? [] : List<dynamic>.from(ibaninfo!.map((x) => x.toJson())),
  };
}

class Ibaninfo {
  String? ibanId;
  String? label;
  String? currency;
  String? balance;
  String? iban;
  String? bic;

  Ibaninfo({
    this.ibanId,
    this.label,
    this.currency,
    this.balance,
    this.iban,
    this.bic,
  });

  factory Ibaninfo.fromJson(Map<String, dynamic> json) => Ibaninfo(
    ibanId: json["iban_id"],
    label: json["label"],
    currency: json["currency"],
    balance: json["balance"],
    iban: json["iban"],
    bic: json["bic"],
  );

  Map<String, dynamic> toJson() => {
    "iban_id": ibanId,
    "label": label,
    "currency": currency,
    "balance": balance,
    "iban": iban,
    "bic": bic,
  };
}
