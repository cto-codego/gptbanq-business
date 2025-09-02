// To parse this JSON data, do
//
//     final swiftAddBeneficiaryModel = swiftAddBeneficiaryModelFromJson(jsonString);

import 'dart:convert';

SwiftAddBeneficiaryModel swiftAddBeneficiaryModelFromJson(String str) => SwiftAddBeneficiaryModel.fromJson(json.decode(str));

String swiftAddBeneficiaryModelToJson(SwiftAddBeneficiaryModel data) => json.encode(data.toJson());

class SwiftAddBeneficiaryModel {
  int? status;
  List<Country>? country;
  List<Curreny>? curreny;
  List<Iban>? iban;

  SwiftAddBeneficiaryModel({
    this.status,
    this.country,
    this.curreny,
    this.iban,
  });

  factory SwiftAddBeneficiaryModel.fromJson(Map<String, dynamic> json) => SwiftAddBeneficiaryModel(
    status: json["status"],
    country: json["country"] == null ? [] : List<Country>.from(json["country"]!.map((x) => Country.fromJson(x))),
    curreny: json["currency"] == null ? [] : List<Curreny>.from(json["currency"]!.map((x) => Curreny.fromJson(x))),
    iban: json["iban"] == null ? [] : List<Iban>.from(json["iban"]!.map((x) => Iban.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "country": country == null ? [] : List<dynamic>.from(country!.map((x) => x.toJson())),
    "currency": curreny == null ? [] : List<dynamic>.from(curreny!.map((x) => x.toJson())),
    "iban": iban == null ? [] : List<dynamic>.from(iban!.map((x) => x.toJson())),
  };
}

class Country {
  String? code;
  String? name;
  String? flag;

  Country({
    this.code,
    this.name,
    this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    code: json["code"],
    name: json["name"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "flag": flag,
  };
}

class Curreny {
  String? code;
  String? countryName;
  String? name;

  Curreny({
    this.code,
    this.countryName,
    this.name,
  });

  factory Curreny.fromJson(Map<String, dynamic> json) => Curreny(
    code: json["code"],
    countryName: json["country_name"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "country_name": countryName,
    "name": name,
  };
}

class Iban {
  String? name;

  Iban({
    this.name,
  });

  factory Iban.fromJson(Map<String, dynamic> json) => Iban(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
