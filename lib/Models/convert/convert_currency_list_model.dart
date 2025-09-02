// To parse this JSON data, do
//
//     final convertCurrencyListModel = convertCurrencyListModelFromJson(jsonString);

import 'dart:convert';

ConvertCurrencyListModel convertCurrencyListModelFromJson(String str) => ConvertCurrencyListModel.fromJson(json.decode(str));

String convertCurrencyListModelToJson(ConvertCurrencyListModel data) => json.encode(data.toJson());

class ConvertCurrencyListModel {
  final int? status;
  final String? message;
  dynamic rate;
  final String? rateLabel;
  final String? sellCurrency;
  final String? buyCurrency;
  final List<CurrencyList>? sellcurrencyList;
  final List<CurrencyList>? buycurrencyList;

  ConvertCurrencyListModel({
    this.status,
    this.message,
    this.rate,
    this.rateLabel,
    this.sellCurrency,
    this.buyCurrency,
    this.sellcurrencyList,
    this.buycurrencyList,
  });

  factory ConvertCurrencyListModel.fromJson(Map<String, dynamic> json) => ConvertCurrencyListModel(
    status: json["status"],
    message: json["message"],
    rate: json["rate"].toString(),
    rateLabel: json["rate_label"],
    sellCurrency: json["sell_currency"],
    buyCurrency: json["buy_currency"],
    sellcurrencyList: json["sellcurrency"] == null ? [] : List<CurrencyList>.from(json["sellcurrency"]!.map((x) => CurrencyList.fromJson(x))),
    buycurrencyList: json["buycurrency"] == null ? [] : List<CurrencyList>.from(json["buycurrency"]!.map((x) => CurrencyList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "rate": rate,
    "rate_label": rateLabel,
    "sell_currency": sellCurrency,
    "buy_currency": buyCurrency,
    "sellcurrency": sellcurrencyList == null ? [] : List<dynamic>.from(sellcurrencyList!.map((x) => x.toJson())),
    "buycurrency": buycurrencyList == null ? [] : List<dynamic>.from(buycurrencyList!.map((x) => x.toJson())),
  };
}

class CurrencyList {
  final String? ibanId;
  final String? currency;
  final String? symbol;
  final String? balance;
  final String? flag;

  CurrencyList({
    this.ibanId,
    this.currency,
    this.symbol,
    this.balance,
    this.flag,
  });

  factory CurrencyList.fromJson(Map<String, dynamic> json) => CurrencyList(
    ibanId: json["iban_id"],
    currency: json["currency"],
    symbol: json["symbol"],
    balance: json["balance"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "iban_id": ibanId,
    "currency": currency,
    "symbol": symbol,
    "balance": balance,
    "flag": flag,
  };
}



