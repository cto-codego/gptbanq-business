// To parse this JSON data, do
//
//     final trxlogmodel = trxlogmodelFromJson(jsonString);

import 'dart:convert';

Trxlogmodel trxlogmodelFromJson(String str) =>
    Trxlogmodel.fromJson(json.decode(str));

class Trxlogmodel {
  String? totalTransacted;
  String? totalPending;
  String? totalCredit;
  String? totalCommission;
  List<Trx>? trx;
  int? numberofpages;
  int? previouspage;
  int? nextpage;

  Trxlogmodel({
    this.totalTransacted,
    this.totalPending,
    this.totalCredit,
    this.totalCommission,
    this.trx,
    this.numberofpages,
    this.previouspage,
    this.nextpage,
  });

  factory Trxlogmodel.fromJson(Map<String, dynamic> json) => Trxlogmodel(
        totalTransacted: json["total_transacted"],
        totalPending: json["total_pending"],
        totalCredit: json["total_credit"],
        totalCommission: json["total_commission"],
        trx: List<Trx>.from(json["trx"].map((x) => Trx.fromJson(x))),
        numberofpages: json["numberofpages"],
        previouspage: json["previouspage"],
        nextpage: json["nextpage"],
      );
}

class Trx {
  String? trxDate;
  String? leagalName;
  String? datePayment;
  String? amount;
  String? commision;
  String? creditAmount;
  String? holdAmount;
  String? isRefunded;
  String? status;

  Trx({
    this.trxDate,
    this.leagalName,
    this.datePayment,
    this.amount,
    this.commision,
    this.creditAmount,
    this.holdAmount,
    this.isRefunded,
    this.status,
  });

  factory Trx.fromJson(Map<String, dynamic> json) => Trx(
        trxDate: json["trx_date"],
        leagalName: json["leagal_name"],
        datePayment: json["date_payment"],
        amount: json["amount"],
        commision: json["commision"],
        creditAmount: json["credit_amount"],
        holdAmount: json["hold_amount"],
        isRefunded: json["is_refunded"],
        status: json["status"],
      );
}
