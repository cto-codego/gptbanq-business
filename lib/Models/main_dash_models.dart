// To parse this JSON data, do
//
//     final maindash = maindashFromJson(jsonString);

import 'dart:convert';

Maindash maindashFromJson(String str) => Maindash.fromJson(json.decode(str));


class Maindash {
    Maindash({
        this.status,
        this.userImage,
        this.userName,
        this.walletBalance,
        this.symbol,
        this.label,
        this.wallet,
        this.qrcode,
        this.currencyName,
        this.planId,
        this.accountId,
        this.card,
        this.debitcard,
        this.transactions,
        this.beneficiary,
        this.totalNotification,
        this.cryptoPortfolio,
        this.isStripe,
        this.isAutotrading,
        this.vc,
        this.isMetal,
        this.isPos,
        this.topupKycStatus,
    });

    int ?status;
    String ?userImage;
    String ?userName;
    String ?walletBalance;
    String ?symbol;
    String ?label;
    String ?wallet;
    String ?qrcode;
    String ?currencyName;
    String ?planId;
    String ?accountId;
    Card ?card;
    Debitcard ?debitcard;
    List<Transaction> ?transactions;
    List<Beneficiary> ?beneficiary;
    int ? totalNotification = 0;
    String ?cryptoPortfolio;
    int ?isStripe;
    int ?isAutotrading;
    int ?vc;
    int ?isMetal;
    int ?isPos;
    int ?topupKycStatus;

    factory Maindash.fromJson(Map<String, dynamic> json) => Maindash(
        status: json["status"],
        userImage: json["user_image"],
        userName: json["user_name"]??'',
        walletBalance: json["wallet_balance"],
        symbol: json["symbol"],
        label: json["label"],
        wallet: json["wallet"],
        qrcode: json["qrcode"],
        currencyName: json["currency_name"],
        planId: json["plan_id"],
        accountId: json["account_id"],
        card: Card.fromJson(json["card"]),
        debitcard: Debitcard.fromJson(json["debitcard"]),
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
        beneficiary: json["beneficiary"] == null  ?[] : List<Beneficiary>.from(json["beneficiary"].map((x) => Beneficiary.fromJson(x))),
        totalNotification: json["total_notification"]??0,
        cryptoPortfolio: json["crypto_portfolio"],
        isStripe: json["is_stripe"],
        isAutotrading: json["is_autotrading"],
        vc: json["vc"],
        isMetal: json["is_metal"],
        isPos: json["is_pos"],
        topupKycStatus: json["topup_kyc_status"],
    );

  
  
}

class Beneficiary {
    Beneficiary({
        this.uniqueId,
        this.name,
        this.bankAccount,
        this.bankIban,
        this.bankAccountNumber,
        this.ukAccountNumber,
        this.ukSortCode,
        this.bankSwiftCode,
        this.bankName,
        this.status,
        this.bankCurrency,
        this.updateDate,
        this.beneficiaryCountry,
        this.accountType,
        this.image,
        this.beneficiaryType,
    });

    String ? uniqueId;
    String ?name;
    String ?bankAccount;
    String ?bankIban;
    String ?bankAccountNumber;
    String ?ukAccountNumber;
    String ?ukSortCode;
    String ?bankSwiftCode;
    String ?bankName;
    String ?status;
    String ?bankCurrency;
    DateTime ?updateDate;
    String ?beneficiaryCountry;
    String ?accountType;
    String ?image;
    String ?beneficiaryType;

    factory Beneficiary.fromJson(Map<String, dynamic> json) => Beneficiary(
        uniqueId: json["unique_id"],
        name: json["name"],
        bankAccount: json["bank_account"],
        bankIban: json["bank_iban"],
        bankAccountNumber: json["bank_account_number"],
        ukAccountNumber: json["uk_account_number"],
        ukSortCode: json["uk_sort_code"],
        bankSwiftCode: json["bank_swift_code"],
        bankName: json["bank_name"],
        status: json["status"],
        bankCurrency: json["bank_currency"],
        updateDate: DateTime.parse(json["update_date"]),
        beneficiaryCountry: json["beneficiary_country"],
        accountType: json["account_type"],
        image: json["image"],
        beneficiaryType: json["beneficiary_type"],
    );

    Map<String, dynamic> toJson() => {
        "unique_id": uniqueId,
        "name": name,
        "bank_account": bankAccount,
        "bank_iban": bankIban,
        "bank_account_number": bankAccountNumber,
        "uk_account_number": ukAccountNumber,
        "uk_sort_code": ukSortCode,
        "bank_swift_code": bankSwiftCode,
        "bank_name": bankName,
        "status": status,
        "bank_currency": bankCurrency,
        "update_date": updateDate?.toIso8601String(),
        "beneficiary_country": beneficiaryCountry,
        "account_type": accountType,
        "image": image,
        "beneficiary_type": beneficiaryType,
    };
}

class Card {
    Card({
        this.balance,
        this.status,
        this.cardStatus,
        this.cardImage,
        this.cardId,
    });

    String ?balance;
    String ?status;
    String ?cardStatus;
    String ?cardImage;
    String ?cardId;

    factory Card.fromJson(Map<String, dynamic> json) => Card(
        balance: json["balance"],
        status: json["status"],
        cardStatus: json["card_status"],
        cardImage: json["card_image"],
        cardId: json["card_id"],
    );

    Map<String, dynamic> toJson() => {
        "balance": balance,
        "status": status,
        "card_status": cardStatus,
        "card_image": cardImage,
        "card_id": cardId,
    };
}



class Debitcard {
    Debitcard({
        this.status,
        this.balance,
        this.cardStatus,
        this.debitCardImage,
    });

    String ?status;
    String ?balance;
    String ?cardStatus;
    String ?debitCardImage;

    factory Debitcard.fromJson(Map<String, dynamic> json) => Debitcard(
        status: json["status"],
        balance: json["balance"],
        cardStatus: json["card_status"],
        debitCardImage: json["debit_card_image"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "balance": balance,
        "card_status": cardStatus,
        "debit_card_image": debitCardImage,
    };
}




class Transaction {
    Transaction({
        this.uniqueId,
        this.transactionId,
        this.type,
        this.transactionType,
        this.currencyId,
        this.description,
        this.status,
        this.amount,
        this.fees,
        this.total,
        this.currencyName,
        this.symbol,
        this.created,
        this.image,
        this.trxMode,
    });

    String ?uniqueId;
    String ?transactionId;
    String ?type;
    String ?transactionType;
    String ?currencyId;
    String ?description;
    String ?status;
    String ?amount;
    String ?fees;
    String ?total;
    String ?currencyName;
    String ?symbol;
    String ?created;
    String ?image;
    String ?trxMode;

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        uniqueId: json["unique_id"],
        transactionId: json["transaction_id"],
        type: json["type"],
        transactionType:json["transaction_type"],
        currencyId: json["currency_id"],
        description: json["description"],
        status: json["status"],
        amount: json["amount"],
        fees: json["fees"],
        total: json["total"],
        currencyName: json["currency_name"],
        symbol: json["symbol"],
        created: json["created"],
        image: json["image"],
        trxMode: json["trx_mode"],
    );


}









