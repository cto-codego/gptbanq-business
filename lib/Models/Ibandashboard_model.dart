// To parse this JSON data, do
//
//     final ibanDashboardModel = ibanDashboardModelFromJson(jsonString);

import 'dart:convert';

IbanDashboardModel ibanDashboardModelFromJson(String str) => IbanDashboardModel.fromJson(json.decode(str));


class IbanDashboardModel {
    String ?status;
    String ?name;
    String ?surname;
    String ?risk;
    String ?readyForIban;
    String ?currency;
    String ?iban;
    String ?bic;
    String ?balance;
    String ?dailyLimit;
    String ?monthlyLimit;
    String ?transactionLimit;
   List<Transactioniban> ?transaction;
      List<Transactioniban> ?fixetransaction;

    String ?link;
    String ?message;

    IbanDashboardModel({
        this.status,
        this.name,
        this.surname,
        this.risk,
        this.readyForIban,
        this.currency,
        this.iban,
        this.bic,
        this.balance,
        this.dailyLimit,
        this.monthlyLimit,
        this.transactionLimit,
        this.transaction,
        this.fixetransaction,
        this.link,
        this.message


    });

    factory IbanDashboardModel.fromJson(Map<String, dynamic> json) => IbanDashboardModel(
        status: json["status"],
        name: json["name"] ??'',
        surname: json["surname"] ?? '',
        risk: json["risk"] ?? '',
        readyForIban: json["ready_for_iban"] ?? '',
        currency: json["currency"] ?? '',
        iban: json["iban"] ?? '',
        bic: json["bic"] ?? '',
        balance: json["balance"] ?? '',
        dailyLimit: json["daily_limit"] ?? '',
        monthlyLimit: json["monthly_limit"] ?? '',
        transactionLimit: json["transaction_limit"] ?? '',
        fixetransaction: List<Transactioniban>.from(json["transaction"].map((x) => Transactioniban.fromJson(x))),

        transaction: List<Transactioniban>.from(json["transaction"].map((x) => Transactioniban.fromJson(x))),
        link: json['link'] ?? '',
        message: json['message'] ??''
    );

  
}

class Transactioniban {
    String ?type;
    String ?amount;
    String ?fee;
    String ?status;
    String ?description;
    String ?transactionId;
    String ?created;

    Transactioniban({
        this.type,
        this.amount,
        this.fee,
        this.status,
        this.description,
        this.transactionId,
        this.created,
    });

    factory Transactioniban.fromJson(Map<String, dynamic> json) => Transactioniban(
        type: json["type"] ?? '',
        amount: json["amount"]??'',
        fee: json["fee"]??'',
        status: json["status"] ??'',
        description: json["description"] ?? '',
        transactionId: json["transaction_id"] ?? '',
        created: json["created"] ??'',
    );

}
