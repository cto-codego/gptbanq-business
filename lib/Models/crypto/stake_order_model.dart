import 'dart:convert';

StakeOrderModel stakeOrderModelFromJson(String str) =>
    StakeOrderModel.fromJson(json.decode(str));

String stakeOrderModelToJson(StakeOrderModel data) =>
    json.encode(data.toJson());

class StakeOrderModel {
  int? status;
  String? orderId;
  String? amount;
  String? coin;
  String? commission;
  String? profit;
  String? period;

  StakeOrderModel({
    this.status,
    this.orderId,
    this.amount,
    this.coin,
    this.commission,
    this.profit,
    this.period,
  });

  factory StakeOrderModel.fromJson(Map<String, dynamic> json) =>
      StakeOrderModel(
        status: json["status"],
        orderId: json["order_id"],
        amount: json["amount"],
        coin: json["coin"],
        commission: json["commission"],
        profit: json["profit"],
        period: json["period"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_id": orderId,
        "amount": amount,
        "coin": coin,
        "commission": commission,
        "profit": profit,
        "period": period,
      };
}
