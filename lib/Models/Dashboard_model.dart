// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

class DashboardModel {
  int? status;
  int? showDeposit;
  int? isShowConversion;
  int? isShowMoveBalance;
  String? cdgText;
  String? accountLabel;
  String? provider;
  String? name;
  String? surname;
  String? risk;
  String? readyForIban;
  String? currencyFlag;
  String? currency;
  String? symbol;
  String? ibanId;
  String? iban;
  String? bic;
  String? balance;
  String? dailyLimit;
  String? monthlyLimit;
  String? transactionLimit;
  String? ibanStatus;
  List<Beneficary>? beneficary;
  Transaction? transaction;
  List<Notification>? notifications;
  String? profileimage;
  String? bankName;
  String? bankAddress;
  The3Dsconf? the3Dsconf;
  Sof? sof;

  DashboardModel({
    this.status,
    this.showDeposit,
    this.isShowConversion,
    this.isShowMoveBalance,
    this.cdgText,
    this.accountLabel,
    this.provider,
    this.name,
    this.surname,
    this.risk,
    this.readyForIban,
    this.currencyFlag,
    this.currency,
    this.symbol,
    this.ibanId,
    this.iban,
    this.bic,
    this.balance,
    this.dailyLimit,
    this.monthlyLimit,
    this.transactionLimit,
    this.ibanStatus,
    this.beneficary,
    this.transaction,
    this.notifications,
    this.profileimage,
    this.the3Dsconf,
    this.bankName,
    this.bankAddress,
    this.sof,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    status: json["status"],
    name: json["name"],
    provider: json["provider"],
    accountLabel: json["account_label"],
    showDeposit: json["show_deposit"],
    isShowConversion: json["is_show_converion"],
    isShowMoveBalance: json["is_show_move_balance"],
    cdgText: json["cdg_text"],
    surname: json["surname"],
    risk: json["risk"],
    readyForIban: json["ready_for_iban"],
    currencyFlag: json["currencyflag"],
    currency: json["currency"],
    symbol: json["symbol"],
    ibanId: json["iban_id"],
    iban: json["iban"] ?? " ",
    bic: json["bic"],
    balance: json["balance"] ?? "0.00",
    dailyLimit: json["daily_limit"],
    monthlyLimit: json["monthly_limit"],
    transactionLimit: json["transaction_limit"],
    ibanStatus: json["iban_status"],
    beneficary: json["beneficary"] == null
        ? []
        : List<Beneficary>.from(
        json["beneficary"]!.map((x) => Beneficary.fromJson(x))),
    transaction: json["transaction"] == null
        ? null
        : Transaction.fromJson(json["transaction"]),
    notifications: json["notifications"] == null
        ? []
        : List<Notification>.from(
        json["notifications"]!.map((x) => Notification.fromJson(x))),
    profileimage: json["profileimage"],
    bankName: json["bank_name"],
    bankAddress: json["bank_address"],
    the3Dsconf: json["3dsconf"] == null
        ? null
        : The3Dsconf.fromJson(json["3dsconf"]),
    sof: json["sof"] == null ? null : Sof.fromJson(json["sof"]),
  );

// Map<String, dynamic> toJson() => {
//   "status": status,
//   "name": name,
//   "surname": surname,
//   "risk": risk,
//   "ready_for_iban": readyForIban,
//   "currency": currency,
//   "iban_id": ibanId,
//   "iban": iban,
//   "bic": bic,
//   "balance": balance,
//   "daily_limit": dailyLimit,
//   "monthly_limit": monthlyLimit,
//   "transaction_limit": transactionLimit,
//   "iban_status": ibanStatus,
//   "beneficary": beneficary == null ? [] : List<dynamic>.from(beneficary!.map((x) => x.toJson())),
//   "transaction": transaction?.toJson(),
//   "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
//   "profileimage": profileimage,
//   "3dsconf": the3Dsconf?.toJson(),
// };
}

class Beneficary {
  String? currency;
  String? uniqueId;
  String? name;
  String? bic;
  String? iban;
  String? profileimage;
  String? accountType;
  String? risk;

  Beneficary({
    this.currency,
    this.uniqueId,
    this.name,
    this.bic,
    this.iban,
    this.profileimage,
    this.accountType,
    this.risk,
  });

  factory Beneficary.fromJson(Map<String, dynamic> json) => Beneficary(
    currency: json["currency"] ?? "",
    uniqueId: json["unique_id"] ?? "",
    name: json["name"] ?? "",
    bic: json["bic"] ?? "",
    iban: json["iban"] ?? "",
    profileimage: json["profileimage"] ?? "",
    accountType: json["account_type"] ?? "",
    risk: json["risk"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "unique_id": uniqueId,
    "name": name,
    "bic": bic,
    "iban": iban,
    "profileimage": profileimage,
    "account_type": accountType,
    "risk": risk,
  };
}

class Notification {
  String? id;
  String? title;
  String? description;
  String? date;

  Notification({
    this.id,
    this.title,
    this.description,
    this.date,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    date: json["date"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date": date,
  };
}

class The3Dsconf {
  int? status;
  String? uniqueId;
  String? body;

  The3Dsconf({
    this.status,
    this.uniqueId,
    this.body,
  });

  factory The3Dsconf.fromJson(Map<String, dynamic> json) => The3Dsconf(
    status: json["status"] ?? "",
    uniqueId: json["unique_id"] ?? "",
    body: json["body"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "unique_id": uniqueId,
    "body": body,
  };
}

class Transaction {
  List<Today>? today;
  List<Yesterday>? yesterday;
  List<Past>? past;

  Transaction({
    this.today,
    this.yesterday,
    this.past,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    today: json["today"] == []
        ? []
        : List<Today>.from(json["today"].map((x) => Today.fromJson(x))),
    yesterday: json["yesterday"] == []
        ? []
        : List<Yesterday>.from(
        json["yesterday"].map((x) => Yesterday.fromJson(x))),
    past: List<Past>.from(json["past"].map((x) => Past.fromJson(x))),
  );
}

class Today {
  String? image;
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
  String? unique_id;
  String? beneficiaryCurrency;

  Today({
    this.image,
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
    this.unique_id,
    this.beneficiaryCurrency,
  });

  factory Today.fromJson(Map<String, dynamic> json) => Today(
    image: json["image"] ?? '',
    type: json["type"] ?? '',
    sign: json["sign"] ?? '',
    beneficiaryName: json["beneficiary_name"] ?? '',
    amount: json["amount"] ?? '',
    fee: json["fee"] ?? '',
    unique_id: json['unique_id'] ?? '',
    currency: json["currency"] ?? '',
    status: json["status"] ?? '',
    description: json["description"] ?? '',
    reasonPayment: json["reason_payment"] ?? '',
    transactionId: json["transaction_id"] ?? '',
    created: json["created"] ?? '',
    beneficiaryCurrency: json["beneficiary_currency"] ?? '',
  );
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
  String? beneficiaryCurrency;

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
    this.beneficiaryCurrency,
  });

  factory Past.fromJson(Map<String, dynamic> json) => Past(
    image: json["image"] ?? "",
    uniqueId: json["unique_id"] ?? "",
    type: json["type"] ?? "",
    sign: json["sign"] ?? "",
    beneficiaryName: json["beneficiary_name"] ?? "",
    amount: json["amount"] ?? "",
    fee: json["fee"] ?? "",
    currency: json["currency"] ?? "",
    status: json["status"] ?? "",
    description: json["description"] ?? "",
    reasonPayment: json["reason_payment"] ?? "",
    transactionId: json["transaction_id"] ?? "",
    created: json["created"] ?? "",
    beneficiaryCurrency: json["beneficiary_currency"] ?? "",
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
    "beneficiary_currency": beneficiaryCurrency,
  };
}

class Yesterday {
  String? image;
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
  String? unique_id;
  String? created;
  String? beneficiaryCurrency;

  Yesterday(
      {this.image,
        this.type,
        this.unique_id,
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
        this.beneficiaryCurrency});

  factory Yesterday.fromJson(Map<String, dynamic> json) => Yesterday(
    image: json["image"],
    type: json["type"],
    unique_id: json['unique_id'],
    sign: json["sign"],
    beneficiaryName: json["beneficiary_name"] ?? '',
    amount: json["amount"],
    fee: json["fee"],
    currency: json["currency"],
    status: json["status"],
    description: json["description"],
    reasonPayment: json["reason_payment"],
    transactionId: json["transaction_id"],
    created: json["created"],
    beneficiaryCurrency: json["beneficiary_currency"],
  );
}

class Sof {
  int? sourceOfWealth;
  String? sourceOfWealthMsg;

  Sof({
    this.sourceOfWealth,
    this.sourceOfWealthMsg,
  });

  factory Sof.fromJson(Map<String, dynamic> json) => Sof(
    sourceOfWealth: json["source_of_wealth"],
    sourceOfWealthMsg: json["source_of_wealth_msg"],
  );

  Map<String, dynamic> toJson() => {
    "source_of_wealth": sourceOfWealth,
    "source_of_wealth_msg": sourceOfWealthMsg,
  };
}
