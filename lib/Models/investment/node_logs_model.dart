// To parse this JSON data, do
//
//     final nodeLogsModel = nodeLogsModelFromJson(jsonString);

import 'dart:convert';

NodeLogsModel nodeLogsModelFromJson(String str) =>
    NodeLogsModel.fromJson(json.decode(str));

String nodeLogsModelToJson(NodeLogsModel data) => json.encode(data.toJson());

class NodeLogsModel {
  int? status;
  String? availableBalance;
  int? numberNode;
  List<Order>? order;

  NodeLogsModel({
    this.status,
    this.availableBalance,
    this.numberNode,
    this.order,
  });

  factory NodeLogsModel.fromJson(Map<String, dynamic> json) => NodeLogsModel(
        status: json["status"],
        availableBalance: json["available_balance"],
        numberNode: json["number_node"],
        order: json["order"] == null
            ? []
            : List<Order>.from(json["order"]!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "available_balance": availableBalance,
        "number_node": numberNode,
        "order": order == null
            ? []
            : List<dynamic>.from(order!.map((x) => x.toJson())),
      };
}

class Order {
  String? orderId;
  String? paidProfit;
  String? start;
  String? end;
  String? profitPercentage;

  Order({
    this.orderId,
    this.paidProfit,
    this.start,
    this.end,
    this.profitPercentage,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        paidProfit: json["paid_profit"],
        start: json["start"],
        end: json["end"],
        profitPercentage: json["profitPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "paid_profit": paidProfit,
        "start":start,
        "end": end,
        "profitPercentage": profitPercentage,
      };
}
