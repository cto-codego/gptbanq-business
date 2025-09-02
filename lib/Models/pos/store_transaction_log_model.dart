// To parse this JSON data, do
//
//     final storeTransactionLogModel = storeTransactionLogModelFromJson(jsonString);

import 'dart:convert';

StoreTransactionLogModel storeTransactionLogModelFromJson(String str) => StoreTransactionLogModel.fromJson(json.decode(str));

String storeTransactionLogModelToJson(StoreTransactionLogModel data) => json.encode(data.toJson());

class StoreTransactionLogModel {
  int? status;
  String? totalPaid;
  String? totalUnpaid;
  List<Log>? log;
  List<Storename>? storename;
  String? period;
  List<String>? perioddrop;

  StoreTransactionLogModel({
    this.status,
    this.totalPaid,
    this.totalUnpaid,
    this.log,
    this.storename,
    this.period,
    this.perioddrop,
  });

  factory StoreTransactionLogModel.fromJson(Map<String, dynamic> json) => StoreTransactionLogModel(
    status: json["status"],
    totalPaid: json["total_paid"],
    totalUnpaid: json["total_unpaid"],
    log: json["log"] == null ? [] : List<Log>.from(json["log"]!.map((x) => Log.fromJson(x))),
    storename: json["storename"] == null ? [] : List<Storename>.from(json["storename"]!.map((x) => Storename.fromJson(x))),
    period: json["period"],
    perioddrop: json["perioddrop"] == null ? [] : List<String>.from(json["perioddrop"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "total_paid": totalPaid,
    "total_unpaid": totalUnpaid,
    "log": log == null ? [] : List<dynamic>.from(log!.map((x) => x.toJson())),
    "storename": storename == null ? [] : List<dynamic>.from(storename!.map((x) => x.toJson())),
    "period": period,
    "perioddrop": perioddrop == null ? [] : List<dynamic>.from(perioddrop!.map((x) => x)),
  };
}

class Log {
  String? uniqueId;
  String? coin;
  String? network;
  String? cryptoAmount;
  String? transactionId;
  String? link;
  String? amount;
  String? fee;
  String? paidAmount;
  String? status;
  DateTime? date;

  Log({
    this.uniqueId,
    this.coin,
    this.network,
    this.cryptoAmount,
    this.transactionId,
    this.link,
    this.amount,
    this.fee,
    this.paidAmount,
    this.status,
    this.date,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    uniqueId: json["unique_id"],
    coin: json["coin"],
    network: json["network"],
    cryptoAmount: json["crypto_amount"],
    transactionId: json["transaction_id"],
    link: json["link"],
    amount: json["amount"],
    fee: json["fee"],
    paidAmount: json["paid_amount"],
    status: json["status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "unique_id": uniqueId,
    "coin": coin,
    "network": network,
    "crypto_amount": cryptoAmount,
    "transaction_id": transactionId,
    "link": link,
    "amount": amount,
    "fee": fee,
    "paid_amount": paidAmount,
    "status": status,
    "date": date?.toIso8601String(),
  };
}

class Storename {
  String? label;
  String? storeId;
  int? selected;

  Storename({
    this.label,
    this.storeId,
    this.selected,
  });

  factory Storename.fromJson(Map<String, dynamic> json) => Storename(
    label: json["label"],
    storeId: json["storeId"],
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "storeId": storeId,
    "selected": selected,
  };
}
