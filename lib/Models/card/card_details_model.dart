// To parse this JSON data, do
//
//     final userCardDetailsModel = userCardDetailsModelFromJson(jsonString);

import 'dart:convert';

UserCardDetailsModel userCardDetailsModelFromJson(String str) => UserCardDetailsModel.fromJson(json.decode(str));

String userCardDetailsModelToJson(UserCardDetailsModel data) => json.encode(data.toJson());

class UserCardDetailsModel {
  int? status;
  UserCardDetails? userCardDetails;

  UserCardDetailsModel({
    this.status,
    this.userCardDetails,
  });

  factory UserCardDetailsModel.fromJson(Map<String, dynamic> json) => UserCardDetailsModel(
    status: json["status"],
    userCardDetails: json["card"] == null ? null : UserCardDetails.fromJson(json["card"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "card": userCardDetails?.toJson(),
  };
}

class UserCardDetails {
  String? cardHolderName;
  int? isActive;
  int? isiframe;
  String? iframeurl;
  String? cardnumber;
  String? fullcardnumber;
  String? expiry;
  String? cvv;
  String? cardImage;
  String? cardType;
  String? balance;
  String? cardMaterial;
  String? isPrepaidDebit;
  String? textStatus;
  String? status;
  String? cid;
  CardSetting? cardSetting;
  String? symbol;
  List<CardTrx>? cardTrx;

  UserCardDetails({
    this.cardHolderName,
    this.isActive,
    this.isiframe,
    this.iframeurl,
    this.cardnumber,
    this.fullcardnumber,
    this.expiry,
    this.cvv,
    this.cardImage,
    this.cardType,
    this.balance,
    this.cardMaterial,
    this.textStatus,
    this.status,
    this.isPrepaidDebit,
    this.cid,
    this.cardSetting,
    this.symbol,
    this.cardTrx,
  });

  factory UserCardDetails.fromJson(Map<String, dynamic> json) => UserCardDetails(
    cardHolderName: json["card_holder_name"],
    isActive: json["is_active"],
    isiframe: json["isiframe"],
    iframeurl: json["iframeurl"],
    cardnumber: json["cardnumber"],
    fullcardnumber: json["fullcardnumber"],
    expiry: json["expiry"],
    cvv: json["cvv"],
    cardImage: json["cardImage"],
    cardType: json["cardType"],
    balance: json["balance"],
    cardMaterial: json["cardMaterial"],
    textStatus: json["text_status"],
    status: json["status"],
    isPrepaidDebit: json["is_prepaid_debit"],
    cid: json["cid"],
    cardSetting: json["card_setting"] == null ? null : CardSetting.fromJson(json["card_setting"]),
    symbol: json["symbol"],
    cardTrx: json["card_trx"] == null ? [] : List<CardTrx>.from(json["card_trx"]!.map((x) => CardTrx.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "card_holder_name": cardHolderName,
    "is_active": isActive,
    "isiframe": isiframe,
    "iframeurl": iframeurl,
    "cardnumber": cardnumber,
    "fullcardnumber": fullcardnumber,
    "expiry": expiry,
    "cvv": cvv,
    "cardImage": cardImage,
    "cardType": cardType,
    "balance": balance,
    "cardMaterial": cardMaterial,
    "text_status": textStatus,
    "status": status,
    "is_prepaid_debit": isPrepaidDebit,
    "cid": cid,
    "card_setting": cardSetting?.toJson(),
    "symbol": symbol,
    "card_trx": cardTrx == null ? [] : List<dynamic>.from(cardTrx!.map((x) => x.toJson())),
  };
}

class CardSetting {
  dynamic dailyLimit;
  dynamic contactlessLimit;
  String? online;
  String? contactless;
  String? recurring;
  String? atmlBlock;
  String? blockCardMessage;

  CardSetting({
    this.dailyLimit,
    this.contactlessLimit,
    this.online,
    this.contactless,
    this.recurring,
    this.atmlBlock,
    this.blockCardMessage,
  });

  factory CardSetting.fromJson(Map<String, dynamic> json) => CardSetting(
    dailyLimit: json["daily_limit"] ?? "0.00",
    contactlessLimit: json["contactless_limit"] ?? "0.00",
    online: json["online"],
    contactless: json["contactless"],
    recurring: json["recurring"],
    atmlBlock: json["atml_block"],
    blockCardMessage: json["block_card_message"],
  );

  Map<String, dynamic> toJson() => {
    "daily_limit": dailyLimit,
    "contactless_limit": contactlessLimit,
    "online": online,
    "contactless": contactless,
    "recurring": recurring,
    "atml_block": atmlBlock,
    "block_card_message": blockCardMessage,
  };
}

class CardTrx {
  String? merchNameDe43;
  String? merchantName;
  String? transactionId;
  String? billingamount;
  String? billingCurrency;
  String? totalPay;
  String? txnDesc;
  String? status;
  String? type;
  String? currency;
  String? symbol;
  String? created;
  String? image;
  String? isShowMerchant;

  CardTrx({
    this.merchNameDe43,
    this.merchantName,
    this.transactionId,
    this.billingamount,
    this.billingCurrency,
    this.totalPay,
    this.txnDesc,
    this.status,
    this.type,
    this.currency,
    this.symbol,
    this.created,
    this.image,
    this.isShowMerchant,
  });

  factory CardTrx.fromJson(Map<String, dynamic> json) => CardTrx(
    merchNameDe43: json["Merch_Name_DE43"] ?? "",
    merchantName: json["merchant_name"] ?? "",
    transactionId: json["transaction_id"] ?? "",
    billingamount: json["billingamount"] ?? "",
    billingCurrency: json["billing_currecny"] ?? "",
    totalPay: json["total_pay"] ?? "",
    txnDesc: json["txnDesc"] ?? "",
    status: json["status"] ?? "",
    type: json["type"] ?? "",
    currency: json["currency"] ?? "",
    symbol: json["symbol"] ?? "",
    created: json["created"] ?? "",
    image: json["image"] ?? "",
    isShowMerchant: json["is_show_merchant"].toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "Merch_Name_DE43": merchNameDe43,
    "merchant_name": merchantName,
    "transaction_id": transactionId,
    "billingamount": billingamount,
    "billing_currecny": billingCurrency,
    "total_pay": totalPay,
    "txnDesc": txnDesc,
    "status": status,
    "type": type,
    "currency": currency,
    "symbol": symbol,
    "created": created,
    "image": image,
    "is_show_merchant": isShowMerchant,
  };
}
