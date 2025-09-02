// To parse this JSON data, do
//
//     final transactionListModel = transactionListModelFromJson(jsonString);

import 'dart:convert';

TransactionListModel transactionListModelFromJson(String str) => TransactionListModel.fromJson(json.decode(str));

String transactionListModelToJson(TransactionListModel data) => json.encode(data.toJson());

class TransactionListModel {
  int? status;
  TransactionList? transaction;
  String? message;

  TransactionListModel({
    this.status,
    this.transaction,
    this.message,
  });

  factory TransactionListModel.fromJson(Map<String, dynamic> json) => TransactionListModel(
    status: json["status"],
    transaction: json["transaction"] == null ? null : TransactionList.fromJson(json["transaction"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "transaction": transaction?.toJson(),
    "message": message,
  };
}

class TransactionList {
  List<Past>? today;
  List<Past>? yesterday;
  List<Past>? past;

  TransactionList({
    this.today,
    this.yesterday,
    this.past,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) => TransactionList(
    today: json["today"] == null ? [] : List<Past>.from(json["today"]!.map((x) => Past.fromJson(x))),
    yesterday: json["yesterday"] == null ? [] : List<Past>.from(json["yesterday"]!.map((x) => Past.fromJson(x))),
    past: json["past"] == null ? [] : List<Past>.from(json["past"]!.map((x) => Past.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "today": today == null ? [] : List<dynamic>.from(today!.map((x) => x.toJson())),
    "yesterday": yesterday == null ? [] : List<dynamic>.from(yesterday!.map((x) => x.toJson())),
    "past": past == null ? [] : List<dynamic>.from(past!.map((x) => x.toJson())),
  };
}

class Past {
  String? image;
  String? uniqueId;
  String? type;
  String? sign;
  String? beneficiaryName;
  String? amount;
  String? fee;
  String? currency;
  String? status;
  String? description;
  String? reasonPayment;
  String? transactionId;
  String? created;

  Past({
    this.image,
    this.uniqueId,
    this.type,
    this.sign,
    this.beneficiaryName,
    this.amount,
    this.fee,
    this.currency,
    this.status,
    this.description,
    this.reasonPayment,
    this.transactionId,
    this.created,
  });

  factory Past.fromJson(Map<String, dynamic> json) => Past(
    image: json["image"],
    uniqueId: json["unique_id"],
    type: json["type"],
    sign: json["sign"],
    beneficiaryName: json["beneficiary_name"],
    amount: json["amount"],
    fee: json["fee"],
    currency: json["currency"],
    status: json["status"],
    description: json["description"],
    reasonPayment: json["reason_payment"],
    transactionId: json["transaction_id"],
    created: json["created"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "unique_id": uniqueId,
    "type": type,
    "sign": sign,
    "beneficiary_name": beneficiaryName,
    "amount": amount,
    "fee": fee,
    "currency": currency,
    "status": status,
    "description": description,
    "reason_payment": reasonPayment,
    "transaction_id": transactionId,
    "created": created,
  };
}
