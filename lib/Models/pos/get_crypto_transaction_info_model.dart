// To parse this JSON data, do
//
//     final getCryptoTransactionInfoModel = getCryptoTransactionInfoModelFromJson(jsonString);

import 'dart:convert';

GetCryptoTransactionInfoModel getCryptoTransactionInfoModelFromJson(
        String str) =>
    GetCryptoTransactionInfoModel.fromJson(json.decode(str));

String getCryptoTransactionInfoModelToJson(
        GetCryptoTransactionInfoModel data) =>
    json.encode(data.toJson());

class GetCryptoTransactionInfoModel {
  int? status;
  Order? order;

  GetCryptoTransactionInfoModel({
    this.status,
    this.order,
  });

  factory GetCryptoTransactionInfoModel.fromJson(Map<String, dynamic> json) =>
      GetCryptoTransactionInfoModel(
        status: json["status"],
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order": order?.toJson(),
      };
}

class Order {
  String? time;
  String? address;
  String? qrcode;
  String? amount;
  String? cryptoAmount;
  String? copyCryptoAmount;
  String? currencyName;
  String? symbol;
  String? price;
  String? image;
  String? network;
  String? transactionId;

  Order({
    this.time,
    this.address,
    this.qrcode,
    this.amount,
    this.cryptoAmount,
    this.copyCryptoAmount,
    this.currencyName,
    this.symbol,
    this.price,
    this.image,
    this.network,
    this.transactionId,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        time: json["time"],
        address: json["address"],
        qrcode: json["qrcode"],
        amount: json["amount"],
        copyCryptoAmount: json["copycryptoAmount"],
        cryptoAmount: json["cryptoAmount"],
        currencyName: json["currency_name"],
        symbol: json["symbol"],
        price: json["price"],
        image: json["image"],
        network: json["network"],
        transactionId: json["transaction_id"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "address": address,
        "qrcode": qrcode,
        "amount": amount,
        "copycryptoAmount": copyCryptoAmount,
        "cryptoAmount": cryptoAmount,
        "currency_name": currencyName,
        "symbol": symbol,
        "price": price,
        "image": image,
        "network": network,
        "transaction_id": transactionId,
      };
}
