// To parse this JSON data, do
//
//     final cryptoPosListModel = cryptoPosListModelFromJson(jsonString);

import 'dart:convert';

CryptoPosListModel cryptoPosListModelFromJson(String str) => CryptoPosListModel.fromJson(json.decode(str));

String cryptoPosListModelToJson(CryptoPosListModel data) => json.encode(data.toJson());

class CryptoPosListModel {
  final int? status;
  final List<Cryptopo>? cryptopos;

  CryptoPosListModel({
    this.status,
    this.cryptopos,
  });

  factory CryptoPosListModel.fromJson(Map<String, dynamic> json) => CryptoPosListModel(
    status: json["status"],
    cryptopos: json["cryptopos"] == null ? [] : List<Cryptopo>.from(json["cryptopos"]!.map((x) => Cryptopo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "cryptopos": cryptopos == null ? [] : List<dynamic>.from(cryptopos!.map((x) => x.toJson())),
  };
}

class Cryptopo {
  final String? paidAmount;
  final String? label;
  final String? id;
  final String? pin;
  final DateTime? date;
  final String? currency;
  final String? flag;

  Cryptopo({
    this.paidAmount,
    this.label,
    this.id,
    this.pin,
    this.date,
    this.currency,
    this.flag,
  });

  factory Cryptopo.fromJson(Map<String, dynamic> json) => Cryptopo(
    paidAmount: json["paid_amount"],
    label: json["label"],
    id: json["id"],
    pin: json["pin"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    currency: json["currency"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "paid_amount": paidAmount,
    "label": label,
    "id": id,
    "pin": pin,
    "date": date?.toIso8601String(),
    "currency": currency,
    "flag": flag,
  };
}
