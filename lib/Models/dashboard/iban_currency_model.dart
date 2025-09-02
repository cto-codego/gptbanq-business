// To parse this JSON data, do
//
//     final ibanCurrencyModel = ibanCurrencyModelFromJson(jsonString);

import 'dart:convert';

IbanCurrencyModel ibanCurrencyModelFromJson(String str) =>
    IbanCurrencyModel.fromJson(json.decode(str));

String ibanCurrencyModelToJson(IbanCurrencyModel data) =>
    json.encode(data.toJson());

class IbanCurrencyModel {
  int? status;
  String? message;
  int iswallet;
  List<Currency>? currency;
  List<Iban>? iban;

  IbanCurrencyModel({
    this.status,
    this.currency,
    required this.iswallet,
    this.iban,
    this.message,
  });

  factory IbanCurrencyModel.fromJson(Map<String, dynamic> json) =>
      IbanCurrencyModel(
        status: json["status"],
        message: json["message"],
        iswallet: json["iswallet"],
        currency: json["currency"] == null
            ? []
            : List<Currency>.from(
            json["currency"]!.map((x) => Currency.fromJson(x))),
        iban: json["iban"] == null
            ? []
            : List<Iban>.from(json["iban"]!.map((x) => Iban.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "iswallet": iswallet,
    "currency": currency == null
        ? []
        : List<dynamic>.from(currency!.map((x) => x.toJson())),
    "iban": iban == null
        ? []
        : List<dynamic>.from(iban!.map((x) => x.toJson())),
  };
}

class Currency {
  String? currency;
  String? flag;

  Currency({
    this.currency,
    this.flag,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    flag: json["flag"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "flag": flag,
    "currency": currency,
  };
}

class Iban {
  String? name;
  String? flag;

  Iban({
    this.name,
    this.flag,
  });

  factory Iban.fromJson(Map<String, dynamic> json) => Iban(
    name: json["name"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "flag": flag,
  };
}
