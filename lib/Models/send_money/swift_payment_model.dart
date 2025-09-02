// To parse this JSON data, do
//
//     final swiftPaymentModel = swiftPaymentModelFromJson(jsonString);

import 'dart:convert';

SwiftPaymentModel swiftPaymentModelFromJson(String str) => SwiftPaymentModel.fromJson(json.decode(str));

String swiftPaymentModelToJson(SwiftPaymentModel data) => json.encode(data.toJson());

class SwiftPaymentModel {
  int? status;
  String? accountNumber;
  String? bicSwift;
  String? aba;
  String? bankCode;
  String? branchCode;
  String? bsbCode;
  String? clabe;
  String? cnaps;
  String? ifsc;
  String? institutionNo;
  String? sortCode;
  String? name;
  String? referncePayment;
  String? paymentOption;
  String? uniqueId;
  String? amount;
  String? exchangeRate;
  String? exchangeFee;
  String? internationalFee;
  String? feeLabel;
  String? exchangeAmount;
  String? yourTotal;
  String? paymentType;
  String? date;
  String? message;
  String? provider;
  String? flag;

  SwiftPaymentModel({
    this.status,
    this.accountNumber,
    this.bicSwift,
    this.aba,
    this.bankCode,
    this.branchCode,
    this.bsbCode,
    this.clabe,
    this.cnaps,
    this.ifsc,
    this.institutionNo,
    this.sortCode,
    this.name,
    this.referncePayment,
    this.paymentOption,
    this.uniqueId,
    this.amount,
    this.exchangeRate,
    this.exchangeFee,
    this.internationalFee,
    this.feeLabel,
    this.exchangeAmount,
    this.yourTotal,
    this.paymentType,
    this.date,
    this.message,
    this.provider,
    this.flag,
  });

  factory SwiftPaymentModel.fromJson(Map<String, dynamic> json) => SwiftPaymentModel(
    status: json["status"],
    accountNumber: json["account_number"],
    bicSwift: json["bic_swift"],
    aba: json["aba"],
    bankCode: json["bank_code"],
    branchCode: json["branch_code"],
    bsbCode: json["bsb_code"],
    clabe: json["clabe"],
    cnaps: json["cnaps"],
    ifsc: json["ifsc"],
    institutionNo: json["institution_no"],
    sortCode: json["sort_code"],
    name: json["name"],
    referncePayment: json["refernce_payment"],
    paymentOption: json["payment_option"],
    uniqueId: json["unique_id"],
    amount: json["amount"],
    exchangeRate: json["exchange_rate"],
    exchangeFee: json["exchange_fee"],
    internationalFee: json["international_fee"],
    feeLabel: json["fee_label"],
    exchangeAmount: json["exchange_amount"],
    yourTotal: json["your_total"],
    paymentType: json["payment_type"],
    date: json["date"],
    message: json["message"],
    provider: json["provider"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "account_number": accountNumber,
    "bic_swift": bicSwift,
    "aba": aba,
    "bank_code": bankCode,
    "branch_code": branchCode,
    "bsb_code": bsbCode,
    "clabe": clabe,
    "cnaps": cnaps,
    "ifsc": ifsc,
    "institution_no": institutionNo,
    "sort_code": sortCode,
    "name": name,
    "refernce_payment": referncePayment,
    "payment_option": paymentOption,
    "unique_id": uniqueId,
    "amount": amount,
    "exchange_rate": exchangeRate,
    "exchange_fee": exchangeFee,
    "international_fee": internationalFee,
    "fee_label": feeLabel,
    "exchange_amount": exchangeAmount,
    "your_total": yourTotal,
    "payment_type": paymentType,
    "date": date,
    "message": message,
    "provider": provider,
    "flag": flag,
  };
}
