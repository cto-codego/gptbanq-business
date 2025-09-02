// To parse this JSON data, do
//
//     final dynamicBeneficiaryFieldModel = dynamicBeneficiaryFieldModelFromJson(jsonString);

import 'dart:convert';

DynamicBeneficiaryFieldModel dynamicBeneficiaryFieldModelFromJson(String str) =>
    DynamicBeneficiaryFieldModel.fromJson(json.decode(str));

String dynamicBeneficiaryFieldModelToJson(DynamicBeneficiaryFieldModel data) =>
    json.encode(data.toJson());

class DynamicBeneficiaryFieldModel {
  int? status;
  String? message;
  List<RecipientBankOption>? recipientBankOptions;
  List<Field>? field;
  List<Country>? country;
  int? isBeneficiaryIdentificationType;
  List<String>? beneficiaryIdentificationType;

  DynamicBeneficiaryFieldModel({
    this.status,
    this.message,
    this.recipientBankOptions,
    this.field,
    this.country,
    this.isBeneficiaryIdentificationType,
    this.beneficiaryIdentificationType,
  });

  factory DynamicBeneficiaryFieldModel.fromJson(Map<String, dynamic> json) =>
      DynamicBeneficiaryFieldModel(
        status: json["status"],
        message: json["message"],
        recipientBankOptions: json["recipient_bank_options"] == null
            ? []
            : List<RecipientBankOption>.from(json["recipient_bank_options"]!
                .map((x) => RecipientBankOption.fromJson(x))),
        field: json["field"] == null
            ? []
            : List<Field>.from(json["field"]!.map((x) => Field.fromJson(x))),
        country: json["country"] == null
            ? []
            : List<Country>.from(
                json["country"]!.map((x) => Country.fromJson(x))),
        isBeneficiaryIdentificationType:
            json["is_beneficiary_identification_type"],
        beneficiaryIdentificationType:
            json["beneficiary_identification_type"] == null
                ? []
                : List<String>.from(
                    json["beneficiary_identification_type"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "recipient_bank_options": recipientBankOptions == null
            ? []
            : List<dynamic>.from(recipientBankOptions!.map((x) => x.toJson())),
        "field": field == null
            ? []
            : List<dynamic>.from(field!.map((x) => x.toJson())),
        "country": country == null
            ? []
            : List<dynamic>.from(country!.map((x) => x.toJson())),
        "is_beneficiary_identification_type": isBeneficiaryIdentificationType,
        "beneficiary_identification_type": beneficiaryIdentificationType == null
            ? []
            : List<dynamic>.from(beneficiaryIdentificationType!.map((x) => x)),
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

class Field {
  String? type;
  String? name;
  String? label;
  String? placeholder;
  String? partner;
  String? validate;
  String? value;

  Field({
    this.type,
    this.name,
    this.label,
    this.placeholder,
    this.partner,
    this.validate,
    this.value,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        type: json["type"],
        name: json["name"],
        label: json["label"],
        placeholder: json["placeholder"],
        partner: json["partner"],
        validate: json["validate"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "label": label,
        "placeholder": placeholder,
        "partner": partner,
        "validate": validate,
        "value": value,
      };
}

class RecipientBankOption {
  String? type;
  List<Field>? field;

  RecipientBankOption({
    this.type,
    this.field,
  });

  factory RecipientBankOption.fromJson(Map<String, dynamic> json) =>
      RecipientBankOption(
        type: json["type"],
        field: json["field"] == null
            ? []
            : List<Field>.from(json["field"]!.map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "field": field == null
            ? []
            : List<dynamic>.from(field!.map((x) => x.toJson())),
      };
}
