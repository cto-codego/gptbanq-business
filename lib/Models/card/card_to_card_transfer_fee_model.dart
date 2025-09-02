// To parse this JSON data, do
//
//     final cardToCardTransferFeeModel = cardToCardTransferFeeModelFromJson(jsonString);

import 'dart:convert';

CardToCardTransferFeeModel cardToCardTransferFeeModelFromJson(String str) => CardToCardTransferFeeModel.fromJson(json.decode(str));

String cardToCardTransferFeeModelToJson(CardToCardTransferFeeModel data) => json.encode(data.toJson());

class CardToCardTransferFeeModel {
  int? status;
  String? currecny;
  String? loadCardFee;
  String? totalPay;

  CardToCardTransferFeeModel({
    this.status,
    this.currecny,
    this.loadCardFee,
    this.totalPay,
  });

  factory CardToCardTransferFeeModel.fromJson(Map<String, dynamic> json) => CardToCardTransferFeeModel(
    status: json["status"],
    currecny: json["currecny"],
    loadCardFee: json["load_card_fee"],
    totalPay: json["total_pay"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "currecny": currecny,
    "load_card_fee": loadCardFee,
    "total_pay": totalPay,
  };
}
