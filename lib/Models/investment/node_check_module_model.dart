// To parse this JSON data, do
//
//     final nodeCheckModuleModel = nodeCheckModuleModelFromJson(jsonString);

import 'dart:convert';

NodeCheckModuleModel nodeCheckModuleModelFromJson(String str) => NodeCheckModuleModel.fromJson(json.decode(str));

String nodeCheckModuleModelToJson(NodeCheckModuleModel data) => json.encode(data.toJson());

class NodeCheckModuleModel {
  int? status;
  int? isInvestment;
  String? stakingProfit;
  String? enduserMasternodeProfit;
  String? period;
  String? wlMasternode;
  String? investmentProfit;

  NodeCheckModuleModel({
    this.status,
    this.isInvestment,
    this.stakingProfit,
    this.enduserMasternodeProfit,
    this.period,
    this.wlMasternode,
    this.investmentProfit,
  });

  factory NodeCheckModuleModel.fromJson(Map<String, dynamic> json) => NodeCheckModuleModel(
    status: json["status"],
    isInvestment: json["is_investment"],
    stakingProfit: json["staking_profit"],
    enduserMasternodeProfit: json["enduser_masternode_profit"],
    period: json["period"],
    wlMasternode: json["wl_masternode"],
    investmentProfit: json["investment_profit"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "is_investment": isInvestment,
    "staking_profit": stakingProfit,
    "enduser_masternode_profit": enduserMasternodeProfit,
    "period": period,
    "wl_masternode": wlMasternode,
    "investment_profit": investmentProfit,
  };
}
