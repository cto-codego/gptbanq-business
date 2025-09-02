// To parse this JSON data, do
//
//     final trxmodel = trxmodelFromJson(jsonString);

import 'dart:convert';

Trxmodel trxmodelFromJson(String str) => Trxmodel.fromJson(json.decode(str));

class Trxmodel {
  List<Trx>? trx;
  var numberofpages;
  var previouspage;
  var nextpage;
  String? totalAmount;
  String? transactionDate;

  Trxmodel({
    this.trx,
    this.numberofpages,
    this.previouspage,
    this.nextpage,
    this.totalAmount,
    this.transactionDate,
  });

  factory Trxmodel.fromJson(Map<String, dynamic> json) => Trxmodel(
        trx: List<Trx>.from(json["trx"].map((x) => Trx.fromJson(x))),
        numberofpages: json["numberofpages"],
        previouspage: json["previouspage"],
        nextpage: json["nextpage"],
        totalAmount: json["total_amount"],
        transactionDate: json["transaction_date"],
      );
}

class Trx {
  String? leagalName;
  String? card;
  String? cardBrand;
  String? authcode;
  String? rawAmount;
  String? commission;
  String? nscc;
  String? status;
  String? paidDate;
  String? transactionDate;
  String? transactionTime;
  String? serviceMsg;
  String? currecny;
  String? symbol;

  Trx({
    this.leagalName,
    this.card,
    this.cardBrand,
    this.authcode,
    this.rawAmount,
    this.commission,
    this.nscc,
    this.status,
    this.paidDate,
    this.transactionDate,
    this.transactionTime,
    this.serviceMsg,
    this.currecny,
    this.symbol,
  });

  factory Trx.fromJson(Map<String, dynamic> json) => Trx(
        leagalName: json["leagal_name"],
        card: json["card"],
        cardBrand: json["card_brand"],
        authcode: json["authcode"],
        rawAmount: json["raw_amount"],
        commission: json["commission"],
        nscc: json["nscc"],
        status: json["status"],
        paidDate: json["paid_date"],
        transactionDate: json["transaction_date"],
        transactionTime: json["transaction_time"],
        serviceMsg: json["service_msg"],
        currecny: json["currecny"],
        symbol: json["symbol"],
      );
}
