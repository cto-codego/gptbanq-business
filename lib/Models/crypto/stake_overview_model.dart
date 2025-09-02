// To parse this JSON data, do
//
//     final stakeOverviewModel = stakeOverviewModelFromJson(jsonString);

import 'dart:convert';

StakeOverviewModel stakeOverviewModelFromJson(String str) =>
    StakeOverviewModel.fromJson(json.decode(str));

String stakeOverviewModelToJson(StakeOverviewModel data) =>
    json.encode(data.toJson());

class StakeOverviewModel {
  int? status;
  List<Log>? logs;
  Overview? overview;
  String? stakingProfit;
  int? isCstaking;
  int? isButton;
  int? isEdit;
  String? amount;
  String? period;
  String? dailyprofit;
  String? thismonthprofit;

  StakeOverviewModel({
    this.status,
    this.logs,
    this.overview,
    this.stakingProfit,
    this.isCstaking,
    this.isButton,
    this.isEdit,
    this.amount,
    this.period,
    this.dailyprofit,
    this.thismonthprofit,
  });

  factory StakeOverviewModel.fromJson(Map<String, dynamic> json) =>
      StakeOverviewModel(
        status: json["status"],
        logs: json["logs"] == null
            ? []
            : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
        overview: json["overview"] == null
            ? null
            : Overview.fromJson(json["overview"]),
        stakingProfit: json["staking_profit"],
        isCstaking: json["is_cstaking"],
        isButton: json["is_button"],
        isEdit: json["is_edit"],
        amount: json["amount"],
        period: json["period"],
        dailyprofit: json["dailyprofit"],
        thismonthprofit: json["thismonthprofit"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "logs": logs == null
            ? []
            : List<dynamic>.from(logs!.map((x) => x.toJson())),
        "overview": overview?.toJson(),
        "staking_profit": stakingProfit,
        "is_cstaking": isCstaking,
        "is_button": isButton,
        "is_edit": isEdit,
        "amount": amount,
        "period": period,
    "dailyprofit": dailyprofit,
    "thismonthprofit": thismonthprofit,
      };
}

class Log {
  String? orderId;
  String? amount;
  String? totalProfit;
  String? coin;
  String? image;
  String? period;
  String? status;

  Log({
    this.orderId,
    this.amount,
    this.totalProfit,
    this.coin,
    this.image,
    this.period,
    this.status,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        orderId: json["order_id"],
        amount: json["amount"],
        totalProfit: json["total_profit"],
        coin: json["coin"],
        image: json["image"],
        period: json["period"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "amount": amount,
        "total_profit": totalProfit,
        "coin": coin,
        "image": image,
        "period": period,
        "status": status,
      };
}

class Overview {
  String? symbol;
  String? totalAmount;
  String? totalProfit;

  Overview({
    this.symbol,
    this.totalAmount,
    this.totalProfit,
  });

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
        symbol: json["symbol"],
        totalAmount: json["total_amount"] ?? "0.00",
        totalProfit: json["total_profit"] ?? "0.00",
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "total_amount": totalAmount,
        "total_profit": totalProfit,
      };
}
