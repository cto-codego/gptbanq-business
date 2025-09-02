// To parse this JSON data, do
//
//     final cdgStakeOverviewModel = cdgStakeOverviewModelFromJson(jsonString);

import 'dart:convert';

CdgStakeOverviewModel cdgStakeOverviewModelFromJson(String str) => CdgStakeOverviewModel.fromJson(json.decode(str));

String cdgStakeOverviewModelToJson(CdgStakeOverviewModel data) => json.encode(data.toJson());

class CdgStakeOverviewModel {
  final int? status;
  final String? message;
  final ListClass? list;
  final String? boostNote;
  final String? pay1PercentageBoot;
  final String? payBasedOnBasePrice;
  final String? defaultPay;
  final String? btnTitle;
  final String? coin;
  final String? cdgTitle;
  final String? cdgBalance;

  CdgStakeOverviewModel({
    this.status,
    this.message,
    this.list,
    this.boostNote,
    this.pay1PercentageBoot,
    this.payBasedOnBasePrice,
    this.defaultPay,
    this.btnTitle,
    this.coin,
    this.cdgTitle,
    this.cdgBalance,
  });

  factory CdgStakeOverviewModel.fromJson(Map<String, dynamic> json) => CdgStakeOverviewModel(
    status: json["status"],
    message: json["message"],
    list: json["list"] == null ? null : ListClass.fromJson(json["list"]),
    boostNote: json["boost_note"],
    pay1PercentageBoot: json["pay_1_percentage_boot"],
    payBasedOnBasePrice: json["pay_based_on_base_price"],
    defaultPay: json["default_pay"],
    btnTitle: json["btn_title"],
    coin: json["coin"],
    cdgTitle: json["cdg_title"],
    cdgBalance: json["cdgBalance"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "list": list?.toJson(),
    "boost_note": boostNote,
    "pay_1_percentage_boot": pay1PercentageBoot,
    "pay_based_on_base_price": payBasedOnBasePrice,
    "default_pay": defaultPay,
    "btn_title": btnTitle,
    "coin": coin,
    "cdg_title": cdgTitle,
    "cdgBalance": cdgBalance,
  };
}

class ListClass {
  final String? deviceSelectedText;
  final String? deviceSelectedValue;
  final String? basePrice;
  final String? baseValue;
  final String? boostPayout;
  final List<int>? boostPercentage;

  ListClass({
    this.deviceSelectedText,
    this.deviceSelectedValue,
    this.basePrice,
    this.baseValue,
    this.boostPayout,
    this.boostPercentage,
  });

  factory ListClass.fromJson(Map<String, dynamic> json) => ListClass(
    deviceSelectedText: json["device_selected_text"],
    deviceSelectedValue: json["device_selected_value"],
    basePrice: json["base_price"],
    baseValue: json["base_value"],
    boostPayout: json["boost_payout"],
    boostPercentage: json["boost_percentage"] == null ? [] : List<int>.from(json["boost_percentage"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "device_selected_text": deviceSelectedText,
    "device_selected_value": deviceSelectedValue,
    "base_price": basePrice,
    "base_value": baseValue,
    "boost_payout": boostPayout,
    "boost_percentage": boostPercentage == null ? [] : List<dynamic>.from(boostPercentage!.map((x) => x)),
  };
}
