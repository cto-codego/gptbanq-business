import 'dart:convert';

StakeFeeBalanceModel stakeFeeBalanceModelFromJson(String str) =>
    StakeFeeBalanceModel.fromJson(json.decode(str));

String stakeFeeBalanceModelToJson(StakeFeeBalanceModel data) =>
    json.encode(data.toJson());

class StakeFeeBalanceModel {
  int? status;
  String? coin;
  String? stakingProfit;
  String? balance;
  String? eurPrice;

  StakeFeeBalanceModel({
    this.status,
    this.coin,
    this.stakingProfit,
    this.balance,
    this.eurPrice,
  });

  factory StakeFeeBalanceModel.fromJson(Map<String, dynamic> json) =>
      StakeFeeBalanceModel(
        status: json["status"],
        coin: json["coin"],
        stakingProfit: json["staking_profit"],
        balance: json["balance"],
        eurPrice: json["eur_price"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "coin": coin,
        "staking_profit": stakingProfit,
        "balance": balance,
        "eur_price": eurPrice,
      };
}
