// To parse this JSON data, do
//
//     final cdgProfitLogModel = cdgProfitLogModelFromJson(jsonString);

import 'dart:convert';

CdgProfitLogModel cdgProfitLogModelFromJson(String str) => CdgProfitLogModel.fromJson(json.decode(str));

String cdgProfitLogModelToJson(CdgProfitLogModel data) => json.encode(data.toJson());

class CdgProfitLogModel {
  final int? status;
  final String? message;
  final String? year;
  final String? serialNumber;
  final String? totalEnduserProfit;
  final String? deviceStatus;
  final List<Onlinehour>? onlinehour;
  final List<Reward>? rewards;

  CdgProfitLogModel({
    this.status,
    this.message,
    this.year,
    this.serialNumber,
    this.totalEnduserProfit,
    this.deviceStatus,
    this.onlinehour,
    this.rewards,
  });

  factory CdgProfitLogModel.fromJson(Map<String, dynamic> json) => CdgProfitLogModel(
    status: json["status"],
    message: json["message"],
    year: json["year"],
    serialNumber: json["serial_number"],
    totalEnduserProfit: json["total_enduser_profit"],
    deviceStatus: json["device_status"],
    onlinehour: json["onlinehour"] == null ? [] : List<Onlinehour>.from(json["onlinehour"]!.map((x) => Onlinehour.fromJson(x))),
    rewards: json["rewards"] == null ? [] : List<Reward>.from(json["rewards"]!.map((x) => Reward.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "year": year,
    "serial_number": serialNumber,
    "total_enduser_profit": totalEnduserProfit,
    "device_status": deviceStatus,
    "onlinehour": onlinehour == null ? [] : List<dynamic>.from(onlinehour!.map((x) => x.toJson())),
    "rewards": rewards == null ? [] : List<dynamic>.from(rewards!.map((x) => x.toJson())),
  };
}

class Onlinehour {
  final String? date;
  final String? hours;

  Onlinehour({
    this.date,
    this.hours,
  });

  factory Onlinehour.fromJson(Map<String, dynamic> json) => Onlinehour(
    date: json["date"],
    hours: json["hours"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "hours": hours,
  };
}

class Reward {
  final String? date;
  final String? profit;

  Reward({
    this.date,
    this.profit,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    date: json["date"],
    profit: json["profit"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "profit": profit,
  };
}
