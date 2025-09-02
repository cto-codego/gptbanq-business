// To parse this JSON data, do
//
//     final swiftDepositModel = swiftDepositModelFromJson(jsonString);

import 'dart:convert';

SwiftDepositModel swiftDepositModelFromJson(String str) => SwiftDepositModel.fromJson(json.decode(str));

String swiftDepositModelToJson(SwiftDepositModel data) => json.encode(data.toJson());

class SwiftDepositModel {
  int? status;
  String? message;
  Account? account;

  SwiftDepositModel({
    this.status,
    this.message,
    this.account,
  });

  factory SwiftDepositModel.fromJson(Map<String, dynamic> json) => SwiftDepositModel(
    status: json["status"],
    message: json["message"],
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "account": account?.toJson(),
  };
}

class Account {
  String? beneficiary;
  String? accountNumber;
  String? bicSwift;
  String? bankName;
  String? bankAddress;

  Account({
    this.beneficiary,
    this.accountNumber,
    this.bicSwift,
    this.bankName,
    this.bankAddress,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    beneficiary: json["beneficiary"],
    accountNumber: json["account_number"],
    bicSwift: json["bic_swift"],
    bankName: json["bank_name"],
    bankAddress: json["bank_address"],
  );

  Map<String, dynamic> toJson() => {
    "beneficiary": beneficiary,
    "account_number": accountNumber,
    "bic_swift": bicSwift,
    "bank_name": bankName,
    "bank_address": bankAddress,
  };
}
