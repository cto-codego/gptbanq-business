import 'dart:convert';

StakeProfitLogModel stakeProfitLogFromJson(String str) =>
    StakeProfitLogModel.fromJson(json.decode(str));

String stakeProfitLogToJson(StakeProfitLogModel data) => json.encode(data.toJson());

class StakeProfitLogModel {
  int? status;
  List<Log>? logs;

  StakeProfitLogModel({
    this.status,
    this.logs,
  });

  factory StakeProfitLogModel.fromJson(Map<String, dynamic> json) => StakeProfitLogModel(
        status: json["status"],
        logs: json["logs"] == null
            ? []
            : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "logs": logs == null
            ? []
            : List<dynamic>.from(logs!.map((x) => x.toJson())),
      };
}

class Log {
  int? id;
  String? coin;
  String? profit;
  String? period;

  Log({
    this.id,
    this.coin,
    this.profit,
    this.period,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["id"],
        coin: json["coin"],
        profit: json["profit"],
        period: json["period"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coin": coin,
        "profit": profit,
        "period": period,
      };
}
