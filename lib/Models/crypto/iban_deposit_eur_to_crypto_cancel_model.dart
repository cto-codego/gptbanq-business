// To parse this JSON data, do
//
//     final ibanDepositEurToCryptoCancelModel = ibanDepositEurToCryptoCancelModelFromJson(jsonString);

import 'dart:convert';

IbanDepositEurToCryptoCancelModel ibanDepositEurToCryptoCancelModelFromJson(String str) => IbanDepositEurToCryptoCancelModel.fromJson(json.decode(str));

String ibanDepositEurToCryptoCancelModelToJson(IbanDepositEurToCryptoCancelModel data) => json.encode(data.toJson());

class IbanDepositEurToCryptoCancelModel {
  int? status;
  String? message;

  IbanDepositEurToCryptoCancelModel({
    this.status,
    this.message,
  });

  factory IbanDepositEurToCryptoCancelModel.fromJson(Map<String, dynamic> json) => IbanDepositEurToCryptoCancelModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
