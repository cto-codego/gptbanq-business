import 'dart:convert';

CardTopUpFeeModel cardTopUpFeeModelFromJson(String str) =>
    CardTopUpFeeModel.fromJson(json.decode(str));

String cardTopUpFeeModelToJson(CardTopUpFeeModel data) =>
    json.encode(data.toJson());

class CardTopUpFeeModel {
  int? status;
  String? loadAmount;
  String? totalFee;
  String? totalPay;
  String? symbol;
  String? ibanId;

  CardTopUpFeeModel(
      {this.status,
      this.loadAmount,
      this.totalFee,
      this.totalPay,
      this.symbol,
      this.ibanId});

  factory CardTopUpFeeModel.fromJson(Map<String, dynamic> json) =>
      CardTopUpFeeModel(
        status: json["status"],
        loadAmount: json["load_amount"],
        totalFee: json["totalFee"],
        totalPay: json["totalPay"],
        symbol: json["symbol"],
        ibanId: json["iban_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "load_amount": loadAmount,
        "totalFee": totalFee,
        "totalPay": totalPay,
        "symbol": symbol,
        "iban_id": ibanId,
      };
}
