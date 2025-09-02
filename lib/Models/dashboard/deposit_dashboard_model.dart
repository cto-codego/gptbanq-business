// To parse this JSON data, do
//
//     final depositDashboardModel = depositDashboardModelFromJson(jsonString);

import 'dart:convert';

DepositDashboardModel depositDashboardModelFromJson(String str) =>
    DepositDashboardModel.fromJson(json.decode(str));

String depositDashboardModelToJson(DepositDashboardModel data) =>
    json.encode(data.toJson());

class DepositDashboardModel {
  final int? status;
  final String? message;
  final String? accountBalance;
  final String? currency;
  final int? isLocal;
  final int? isSwift;
  final String? currencyflag;
  final AccountDetails? account;

  DepositDashboardModel({
    this.status,
    this.message,
    this.accountBalance,
    this.currency,
    this.isLocal,
    this.isSwift,
    this.currencyflag,
    this.account,
  });

  factory DepositDashboardModel.fromJson(Map<String, dynamic> json) =>
      DepositDashboardModel(
        status: json["status"],
        message: json["message"],
        accountBalance: json["account_balance"],
        currency: json["currency"],
        isLocal: json["is_local"],
        isSwift: json["is_swift"],
        currencyflag: json["currencyflag"],
        account: json["account"] == null
            ? null
            : AccountDetails.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "account_balance": accountBalance,
    "currency": currency,
    "is_local": isLocal,
    "is_swift": isSwift,
    "currencyflag": currencyflag,
    "account": account?.toJson(),
  };
}

class AccountDetails {
  final Local? local;
  final Local? swift;

  AccountDetails({
    this.local,
    this.swift,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) => AccountDetails(
    local: json["local"] == null ? null : Local.fromJson(json["local"]),
    swift: json["swift"] == null ? null : Local.fromJson(json["swift"]),
  );

  Map<String, dynamic> toJson() => {
    "local": local?.toJson(),
    "swift": swift?.toJson(),
  };
}

class Local {
  final String? accountLabel;
  final String? routeLabel;
  final String? beneficiary;
  final String? iban;
  final String? bicSwift;
  final String? bankName;
  final String? reference;
  String? note;
  final String? bankAddress;

  Local({
    this.accountLabel,
    this.routeLabel,
    this.beneficiary,
    this.reference,
    this.iban,
    this.bicSwift,
    this.bankName,
    this.note,
    this.bankAddress,
  });

  factory Local.fromJson(Map<String, dynamic> json) => Local(
    accountLabel: json["account_label"],
    routeLabel: json["route_label"],
    beneficiary: json["beneficiary"],
    iban: json["iban"],
    bicSwift: json["bic_swift"],
    reference: json["reference"],
    note: json["note"],
    bankName: json["bank_name"],
    bankAddress: json["bank_address"],
  );

  Map<String, dynamic> toJson() => {
    "account_label": accountLabel,
    "route_label": routeLabel,
    "beneficiary": beneficiary,
    "iban": iban,
    "bic_swift": bicSwift,
    "reference": reference,
    "note": note,
    "bank_name": bankName,
    "bank_address": bankAddress,
  };
}
