// To parse this JSON data, do
//
//     final stakeCustomPeriodModel = stakeCustomPeriodModelFromJson(jsonString);

import 'dart:convert';

StakeCustomPeriodModel stakeCustomPeriodModelFromJson(String str) => StakeCustomPeriodModel.fromJson(json.decode(str));

String stakeCustomPeriodModelToJson(StakeCustomPeriodModel data) => json.encode(data.toJson());

class StakeCustomPeriodModel {
  int? sttaus;
  List<Period>? period;
  String? message;

  StakeCustomPeriodModel({
    this.sttaus,
    this.period,
    this.message,
  });

  factory StakeCustomPeriodModel.fromJson(Map<String, dynamic> json) => StakeCustomPeriodModel(
    sttaus: json["sttaus"],
    period: json["period"] == null ? [] : List<Period>.from(json["period"]!.map((x) => Period.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "sttaus": sttaus,
    "period": period == null ? [] : List<dynamic>.from(period!.map((x) => x.toJson())),
    "message": message,
  };
}

class Period {
  String? month;
  String? profit;

  Period({
    this.month,
    this.profit,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
    month: json["month"],
    profit: json["profit"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "profit": profit,
  };
}
