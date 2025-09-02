// To parse this JSON data, do
//
//     final stakePeriodModel = stakePeriodModelFromJson(jsonString);

import 'dart:convert';

StakePeriodModel stakePeriodModelFromJson(String str) => StakePeriodModel.fromJson(json.decode(str));

String stakePeriodModelToJson(StakePeriodModel data) => json.encode(data.toJson());

class StakePeriodModel {
  int? sttaus;
  List<int>? period;

  StakePeriodModel({
    this.sttaus,
    this.period,
  });

  factory StakePeriodModel.fromJson(Map<String, dynamic> json) => StakePeriodModel(
    sttaus: json["sttaus"],
    period: json["period"] == null ? [] : List<int>.from(json["period"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "sttaus": sttaus,
    "period": period == null ? [] : List<dynamic>.from(period!.map((x) => x)),
  };
}
