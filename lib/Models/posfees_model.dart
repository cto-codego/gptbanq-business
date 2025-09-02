// To parse this JSON data, do
//
//     final posFeesModel = posFeesModelFromJson(jsonString);

import 'dart:convert';

PosFeesModel posFeesModelFromJson(String str) =>
    PosFeesModel.fromJson(json.decode(str));

class PosFeesModel {
  int? status;
  Plan? plan;

  PosFeesModel({
    this.status,
    this.plan,
  });

  factory PosFeesModel.fromJson(Map<String, dynamic> json) => PosFeesModel(
        status: json["status"],
        plan: Plan.fromJson(json["plan"]),
      );
}

class Plan {
  String? planName;
  String? monthlyFee;
  String? cardTrxFee;

  Plan({
    this.planName,
    this.monthlyFee,
    this.cardTrxFee,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        planName: json["plan_name"],
        monthlyFee: json["monthly_fee"],
        cardTrxFee: json["card_trx_fee"],
      );

  Map<String, dynamic> toJson() => {
        "plan_name": planName,
        "monthly_fee": monthlyFee,
        "card_trx_fee": cardTrxFee,
      };
}
