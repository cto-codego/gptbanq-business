// To parse this JSON data, do
//
//     final giftCardDetailsModel = giftCardDetailsModelFromJson(jsonString);

import 'dart:convert';

GiftCardDetailsModel giftCardDetailsModelFromJson(String str) =>
    GiftCardDetailsModel.fromJson(json.decode(str));

String giftCardDetailsModelToJson(GiftCardDetailsModel data) =>
    json.encode(data.toJson());

class GiftCardDetailsModel {
  int? status;
  Card? card;
  String? image;

  GiftCardDetailsModel({
    this.status,
    this.card,
    this.image,
  });

  factory GiftCardDetailsModel.fromJson(Map<String, dynamic> json) =>
      GiftCardDetailsModel(
        status: json["status"],
        card: json["card"] == null ? null : Card.fromJson(json["card"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "card": card?.toJson(),
        "image": image,
      };
}

class Card {
  String? uniqueId;
  String? loadedAmount;
  String? fee;
  String? totalPay;
  String? description;
  String? cardNumber;
  String? expiryDate;
  String? cvv;
  String? cardStatus;
  DateTime? created;
  String? balance;
  List<Trx>? trx;

  Card({
    this.uniqueId,
    this.loadedAmount,
    this.fee,
    this.totalPay,
    this.description,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.cardStatus,
    this.created,
    this.balance,
    this.trx,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        uniqueId: json["unique_id"],
        loadedAmount: json["loaded_amount"],
        fee: json["fee"],
        totalPay: json["total_pay"],
        description: json["description"],
        cardNumber: json["card_number"],
        expiryDate: json["expiry_date"],
        cvv: json["cvv"],
        cardStatus: json["card_status"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        balance: json["balance"],
        trx: json["trx"] == null
            ? []
            : List<Trx>.from(json["trx"]!.map((x) => Trx.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unique_id": uniqueId,
        "loaded_amount": loadedAmount,
        "fee": fee,
        "total_pay": totalPay,
        "description": description,
        "card_number": cardNumber,
        "expiry_date": expiryDate,
        "cvv": cvv,
        "card_status": cardStatus,
        "created": created?.toIso8601String(),
        "balance": balance,
        "trx":
            trx == null ? [] : List<dynamic>.from(trx!.map((x) => x.toJson())),
      };
}

class Trx {
  String? type;
  String? merchant;
  String? merchantName;
  String? merchantCity;
  String? merchantPostcode;
  String? merchantCountry;
  String? status;
  String? image;
  String? trxid;
  String? amount;
  String? currency;
  String? symbol;
  String? description;
  String? transactionDate;

  Trx({
    this.type,
    this.merchant,
    this.merchantName,
    this.merchantCity,
    this.merchantPostcode,
    this.merchantCountry,
    this.status,
    this.image,
    this.trxid,
    this.amount,
    this.currency,
    this.symbol,
    this.description,
    this.transactionDate,
  });

  factory Trx.fromJson(Map<String, dynamic> json) => Trx(
        type: json["type"],
        merchant: json["merchant"],
        merchantName: json["merchant_name"],
        merchantCity: json["merchant_city"],
        merchantPostcode: json["merchant_postcode"],
        merchantCountry: json["merchant_country"],
        status: json["status"],
        image: json["image"],
        trxid: json["trxid"],
        amount: json["amount"],
        currency: json["currency"],
        symbol: json["symbol"],
        description: json["description"],
        transactionDate: json["transaction_date"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "merchant": merchant,
        "merchant_name": merchantName,
        "merchant_city": merchantCity,
        "merchant_postcode": merchantPostcode,
        "merchant_country": merchantCountry,
        "status": status,
        "image": image,
        "trxid": trxid,
        "amount": amount,
        "currency": currency,
        "symbol": symbol,
        "description": description,
        "transaction_date": transactionDate,
      };
}
