// To parse this JSON data, do
//
//     final refreshSumSubTokenModel = refreshSumSubTokenModelFromJson(jsonString);

import 'dart:convert';

RefreshSumSubTokenModel refreshSumSubTokenModelFromJson(String str) =>
    RefreshSumSubTokenModel.fromJson(json.decode(str));

String refreshSumSubTokenModelToJson(RefreshSumSubTokenModel data) =>
    json.encode(data.toJson());

class RefreshSumSubTokenModel {
  int? status;
  String? sumsubtoken;

  RefreshSumSubTokenModel({
    this.status,
    this.sumsubtoken,
  });

  factory RefreshSumSubTokenModel.fromJson(Map<String, dynamic> json) =>
      RefreshSumSubTokenModel(
        status: json["status"],
        sumsubtoken: json["sumsubtoken"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "sumsubtoken": sumsubtoken,
  };
}
