// To parse this JSON data, do
//
//     final currencyRateModel = currencyRateModelFromJson(jsonString);

import 'dart:convert';

CurrencyRateModel currencyRateModelFromJson(String str) => CurrencyRateModel.fromJson(json.decode(str));

String currencyRateModelToJson(CurrencyRateModel data) => json.encode(data.toJson());

class CurrencyRateModel {
  final int? status;
  dynamic rate;
  final String? message;
  final String? rateLabel;
  final String? sellCurrency;
  final String? buyCurrency;

  CurrencyRateModel({
    this.status,
    this.rate,
    this.message,
    this.rateLabel,
    this.sellCurrency,
    this.buyCurrency,
  });

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) => CurrencyRateModel(
    status: json["status"],
    rate: json["rate"].toString(),
    message: json["message"],
    rateLabel: json["rate_label"],
    sellCurrency: json["sell_currency"],
    buyCurrency: json["buy_currency"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "rate": rate,
    "message": message,
    "rate_label": rateLabel,
    "sell_currency": sellCurrency,
    "buy_currency": buyCurrency,
  };
}
