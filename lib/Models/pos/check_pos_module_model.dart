// To parse this JSON data, do
//
//     final checkPosModuleModel = checkPosModuleModelFromJson(jsonString);

import 'dart:convert';

CheckPosModuleModel checkPosModuleModelFromJson(String str) => CheckPosModuleModel.fromJson(json.decode(str));

String checkPosModuleModelToJson(CheckPosModuleModel data) => json.encode(data.toJson());

class CheckPosModuleModel {
  int? status;
  int? isPos;
  Posplan? posplan;
  String? cryptoTrxfee;

  CheckPosModuleModel({
    this.status,
    this.isPos,
    this.posplan,
    this.cryptoTrxfee,
  });

  factory CheckPosModuleModel.fromJson(Map<String, dynamic> json) => CheckPosModuleModel(
    status: json["status"],
    isPos: json["is_pos"],
    posplan: json["posplan"] == null ? null : Posplan.fromJson(json["posplan"]),
    cryptoTrxfee: json["cryptoTrxfee"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_pos": isPos,
    "posplan": posplan?.toJson(),
    "cryptoTrxfee": cryptoTrxfee,
  };
}

class Posplan {
  String? planName;
  String? monthlyFee;
  String? cardTrxFee;

  Posplan({
    this.planName,
    this.monthlyFee,
    this.cardTrxFee,
  });

  factory Posplan.fromJson(Map<String, dynamic> json) => Posplan(
    planName: json["plan_name"] ?? "",
    monthlyFee: json["monthly_fee"],
    cardTrxFee: json["card_trx_fee"],
  );

  Map<String, dynamic> toJson() => {
    "plan_name": planName,
    "monthly_fee": monthlyFee,
    "card_trx_fee": cardTrxFee,
  };
}
