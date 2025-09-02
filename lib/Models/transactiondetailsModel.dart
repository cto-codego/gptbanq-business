// To parse this JSON data, do
//
//     final transactiondetailsmodel = transactiondetailsmodelFromJson(jsonString);

import 'dart:convert';

Transactiondetailsmodel transactiondetailsmodelFromJson(String str) => Transactiondetailsmodel.fromJson(json.decode(str));

String transactiondetailsmodelToJson(Transactiondetailsmodel data) => json.encode(data.toJson());

class Transactiondetailsmodel {
    int? status;
    Trxdata? trxdata;

    Transactiondetailsmodel({
        this.status,
        this.trxdata,
    });

    factory Transactiondetailsmodel.fromJson(Map<String, dynamic> json) => Transactiondetailsmodel(
        status: json["status"],
        trxdata: json["trxdata"] == null ? null : Trxdata.fromJson(json["trxdata"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "trxdata": trxdata?.toJson(),
    };
}

class Trxdata {
    String? paymentMode;
    String? transactionId;
    String? uniqueId;
    String? mode;
    String? accountHolder;
    String? transactionDate;
    String? reference;
    String? status;
    String? amount;
    String? fee;
    String? currency;
    String? label;
    String? beneficiaryCurrency;
    String? beneficiaryName;
    String? receiverIban;
    String? receiverBic;
    String? receiptGet;
    String? exchangeRate;
    String? exchangeAmount;
    String? exchangeFee;
    String? internationFee;
    String? totalPay;
    String? beneficiaryAccount;
    String? fees;
    String? afterBalance;
    String? beforeBalance;
    String? convertAmount;
    String? trxMode;
    String? note;

    Trxdata({
        this.paymentMode,
        this.transactionId,
        this.uniqueId,
        this.mode,
        this.accountHolder,
        this.transactionDate,
        this.reference,
        this.status,
        this.amount,
        this.fee,
        this.currency,
        this.label,
        this.beneficiaryCurrency,
        this.beneficiaryName,
        this.receiverIban,
        this.receiverBic,
        this.receiptGet,
        this.exchangeRate,
        this.exchangeAmount,
        this.exchangeFee,
        this.internationFee,
        this.totalPay,
        this.beneficiaryAccount,
        this.fees,
        this.afterBalance,
        this.beforeBalance,
        this.convertAmount,
        this.trxMode,
        this.note,
    });

    factory Trxdata.fromJson(Map<String, dynamic> json) => Trxdata(
        paymentMode: json["payment_mode"],
        transactionId: json["transaction_id"],
        uniqueId: json["unique_id"],
        mode: json["mode"],
        accountHolder: json["account_holder"],
        transactionDate: json["transaction_date"],
        reference: json["reference"],
        status: json["status"],
        amount: json["amount"],
        fee: json["fee"],
        currency: json["currency"],
        label: json["label"],
        beneficiaryCurrency: json["beneficiary_currency"],
        beneficiaryName: json["beneficiary_name"],
        receiverIban: json["receiver_iban"],
        receiverBic: json["receiver_bic"],
        receiptGet: json["receipt_get"],
        exchangeRate: json["exchange_rate"],
        exchangeAmount: json["exchange_amount"],
        exchangeFee: json["exchange_fee"],
        internationFee: json["internation_fee"],
        totalPay: json["totalPay"],
        beneficiaryAccount: json["beneficiary_account"],
        fees: json["fees"],
        afterBalance: json["after_balance"],
        beforeBalance: json["before_balance"],
        convertAmount: json["convert_amount"],
        trxMode: json["trx_mode"],
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "payment_mode": paymentMode,
        "transaction_id": transactionId,
        "unique_id": uniqueId,
        "mode": mode,
        "account_holder": accountHolder,
        "transaction_date": transactionDate,
        "reference": reference,
        "status": status,
        "amount": amount,
        "fee": fee,
        "currency": currency,
        "label": label,
        "beneficiary_currency": beneficiaryCurrency,
        "beneficiary_name": beneficiaryName,
        "receiver_iban": receiverIban,
        "receiver_bic": receiverBic,
        "receipt_get": receiptGet,
        "exchange_rate": exchangeRate,
        "exchange_amount": exchangeAmount,
        "exchange_fee": exchangeFee,
        "internation_fee": internationFee,
        "totalPay": totalPay,
        "beneficiary_account": beneficiaryAccount,
        "fees": fees,
        "after_balance": afterBalance,
        "before_balance": beforeBalance,
        "convert_amount": convertAmount,
        "trx_mode": trxMode,
        "note": note,
    };
}
