// To parse this JSON data, do
//
//     final buyMasterNodeModel = buyMasterNodeModelFromJson(jsonString);

import 'dart:convert';

BuyMasterNodeModel buyMasterNodeModelFromJson(String str) => BuyMasterNodeModel.fromJson(json.decode(str));

String buyMasterNodeModelToJson(BuyMasterNodeModel data) => json.encode(data.toJson());

class BuyMasterNodeModel {
  int? status;
  String? coin;
  String? masternodePrice;
  String? totalPaymentDay;
  String? termsCondition;
  String? perDayProfit;
  List<int>? dropList;

  BuyMasterNodeModel({
    this.status,
    this.coin,
    this.masternodePrice,
    this.totalPaymentDay,
    this.termsCondition,
    this.perDayProfit,
    this.dropList,
  });

  factory BuyMasterNodeModel.fromJson(Map<String, dynamic> json) => BuyMasterNodeModel(
    status: json["status"],
    coin: json["coin"],
    masternodePrice: json["masternode_price"],
    totalPaymentDay: json["total_payment_day"],
    termsCondition: json["terms_condition"],
    perDayProfit: json["per_day_profit"],
    dropList: json["dropList"] == null ? [] : List<int>.from(json["dropList"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "coin": coin,
    "masternode_price": masternodePrice,
    "total_payment_day": totalPaymentDay,
    "terms_condition": termsCondition,
    "per_day_profit": perDayProfit,
    "dropList": dropList == null ? [] : List<dynamic>.from(dropList!.map((x) => x)),
  };
}
