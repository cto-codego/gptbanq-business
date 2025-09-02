// To parse this JSON data, do
//
//     final nodeProfitLogModel = nodeProfitLogModelFromJson(jsonString);

import 'dart:convert';

NodeProfitLogModel nodeProfitLogModelFromJson(String str) =>
    NodeProfitLogModel.fromJson(json.decode(str));

String nodeProfitLogModelToJson(NodeProfitLogModel data) =>
    json.encode(data.toJson());

class NodeProfitLogModel {
  int? status;
  String? orderId;
  String? totalPaid;
  List<Log>? logs;

  NodeProfitLogModel({
    this.status,
    this.orderId,
    this.totalPaid,
    this.logs,
  });

  factory NodeProfitLogModel.fromJson(Map<String, dynamic> json) =>
      NodeProfitLogModel(
        status: json["status"],
        orderId: json["order_id"],
        totalPaid: json["totalPaid"],
        logs: json["logs"] == null
            ? []
            : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_id": orderId,
        "totalPaid": totalPaid,
        "logs": logs == null
            ? []
            : List<dynamic>.from(logs!.map((x) => x.toJson())),
      };
}

class Log {
  int? id;
  String? profit;
  String? date;
  String? status;

  Log({
    this.id,
    this.profit,
    this.date,
    this.status,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["id"],
        profit: json["profit"],
        date: json["date"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profit": profit,
        "date": date,
        "status": status,
      };
}
