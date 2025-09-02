// To parse this JSON data, do
//
//     final cardDetails = cardDetailsFromJson(jsonString);

import 'dart:convert';

CardDetails cardDetailsFromJson(String str) => CardDetails.fromJson(json.decode(str));


class CardDetails {
    CardDetails({
         this.transactions,
         this.status,
         this.cardImage,
         this.virtualCardImage,
         this.cardDetails,
         this.fixedtransactions,
         this.isVirtual,
         this.isLivenes, 
         this.isActive,
         this.debitbalance,
    });

    List<Transactioncard> ?transactions=[];
     List<Transactioncard> ?fixedtransactions=[];

     String ? debitbalance;

    int? status;
    String ?cardImage;
    String ?virtualCardImage;
    CardDetailsClass ?cardDetails;
    int ? isVirtual;
        String ?isLivenes;
        int ?isActive;


    factory CardDetails.fromJson(Map<String, dynamic> json) => CardDetails(
        transactions:json["transactions"] == null? []: List<Transactioncard>.from(json["transactions"].map((x) => Transactioncard.fromJson(x))) ,
        fixedtransactions:json["transactions"] == null? []: List<Transactioncard>.from(json["transactions"].map((x) => Transactioncard.fromJson(x))) ,

        status: json["status"],
         isLivenes: json['is_livenes'] ?? '',
         isActive: json['is_suspend_active'] ?? 222,

         debitbalance: json['debit_balance'],
         

        

        isVirtual :json['is_virtual'] ?? 222,
        cardImage: json["card_image"]??'',
        virtualCardImage: json["virtual_card_image"],
        cardDetails: CardDetailsClass.fromJson(json["card_details"]) ,
    );


}

class CardDetailsClass {
    CardDetailsClass({
         this.id,
         this.cardPlasticVirtual,
         this.bankAccountId,
         this.cardNumber,
         this.expiryDate,
         this.balance,
         this.cardType,
         this.allowOnlinePayment,
         this.allowAtmWithdrawal,
         this.allowAbroadPayments,
         this.cardLock,
         this.dailyWithdrawalLimit,
         this.withdrawMonthlyFixedLimit,
         this.dailyPaymentLimit,
         this.monthlyFixedPaymentLimit,
         this.issueDate,
         this.status,
         this.requestStatus,
         this.cardKycStatus,
         this.isVirtual,
         this.userWallet,
         this.cardId,
         this.virtualCardNumber,
         this.cardStatus,
         this.dailyLoadLimit,
         this.dailyLoadFrequencyLimit,
         this.spend,
         this.spent,
         this.isLivness,
         this.cardProvider,
         this.spendtoday,
    });

    String ?id;
    String ?cardPlasticVirtual;
    String ?bankAccountId;
    String ?cardNumber;
    String ?expiryDate;
    String ?balance=' ';
    String ?cardType;
    String ?allowOnlinePayment;
    String ?allowAtmWithdrawal;
    String ?allowAbroadPayments;
    String ?cardLock;
    String ?dailyWithdrawalLimit;
    String ?withdrawMonthlyFixedLimit;
    String ?dailyPaymentLimit;
    String ?monthlyFixedPaymentLimit;
    String ?issueDate;
    String ?status;
    String ?requestStatus;
    String ?cardKycStatus;
    String ?isVirtual;
    String ?userWallet;
    String ?cardId;
    String ?virtualCardNumber;
    String ?cardStatus;
    String ?spent;
    String ?spend;
        String ?spendtoday;

    String ?dailyLoadLimit;
    String ?dailyLoadFrequencyLimit;
    String ?isLivness;

    String ?cardProvider;

    factory CardDetailsClass.fromJson(Map<String, dynamic> json) => CardDetailsClass(
        id: json["id"] ?? '',
        cardPlasticVirtual: json["card_plastic_virtual"] ?? '',
        spendtoday :json['todayspent'] ?? '',
        bankAccountId: json["bank_account_id"] ?? '',
        cardNumber: json["card_number"] ??'',
        expiryDate: json["expiry_date"] ??'',
        balance: json["balance"] ??' ',
        isLivness: json['is_livenes'] ?? '',
        cardProvider: json['cardProvider'] ?? '',
        cardType: json["card_type"] ?? '',
        allowOnlinePayment: json["allow_online_payment"] ?? '',
        allowAtmWithdrawal: json["allow_atm_withdrawal"] ?? '',
        allowAbroadPayments: json["allow_abroad_payments"] ?? '',
        cardLock: json["card_lock"] ?? '',
        dailyWithdrawalLimit: json["daily_withdrawal_limit"] ?? '',
        withdrawMonthlyFixedLimit: json["withdraw_monthly_fixed_limit"] ?? '',
        dailyPaymentLimit: json["daily_payment_limit"] ?? '',
        monthlyFixedPaymentLimit: json["monthly_fixed_payment_limit"] ?? '',
        issueDate: json["issue_date"] ?? '',
        status: json["status"] ?? '',
        requestStatus: json["request_status"] ?? '',
        cardKycStatus: json["card_kyc_status"] ?? '',
        isVirtual: json["is_virtual"] ?? '',
        userWallet: json["user_wallet"] ?? '',
        cardId: json["card_id"] ?? "",
        virtualCardNumber: json["virtual_card_number"] ?? '',
        cardStatus: json["card_status"] ?? '',
        dailyLoadLimit: json["DailyLoadLimit"] ??'',
        dailyLoadFrequencyLimit: json["DailyLoadFrequencyLimit"] ?? '',
         spent: json["spent"] ?? '0',
        spend: json["spend"] ?? '',
    );


}


class Transactioncard {
    Transactioncard({
         this.id,
         this.userId,
         this.userWallet,
         this.adminId,
         this.resellerId,
         this.isVirtual,
         this.username,
         this.uniqueId,
         this.cardId,
         this.whitelabelId,
         this.transactionDate,
         this.amount,
         this.currency,
         this.description,
         this.img,
         this.created,
         this.image,
         this.currencyId,
         this.currencyName,
         this.fees,
         this.status,
         this.symbol,
         this.total,
         this.transactionId,
         this.trxMode,
         this.type,
         this.trxStatus
         
    });

    String ?id;
    String ?userId;
    String ?userWallet;
    String ?adminId;
    String ?resellerId;
    String ?isVirtual;
    String ?username;
    String ?uniqueId;
    String ?cardId;
    String ?whitelabelId;
    String ?transactionDate;
    String ?amount;
    String ?currency;
    String ?description;
    String ?img;
    String ?created;

    String ?image;
    String ?transactionId;
    String ?type;
    String ?currencyId;
    String ?status;
    String ?fees;
    String ?total;
    String ?currencyName;
    String ?symbol;
    String ?trxMode;

    String ? trxStatus;







    factory Transactioncard.fromJson(Map<String, dynamic> json) => Transactioncard(
        id: json["id"] ??'',
        userId: json["user_id"]??'',
        userWallet: json["user_wallet"] ??'',
        adminId: json["admin_id"]??'',
        resellerId: json["reseller_id"]??'',
        isVirtual: json["is_virtual"]??'',
        username: json["username"]??'',
        uniqueId: json["unique_id"]??'',
        cardId: json["card_id"]??'',
        whitelabelId: json["whitelabel_id"] ?? '',
        transactionDate: json["transaction_date"] ?? json["created"] ,
        amount: json["amount"] ?? '',
        currency: json["currency"] ?? '',
        description: json["description"] ?? '',
        img: json["img"] ?? json["image"],
        created:json["created"] ?? '',

                trxStatus: json['trxs_status'] ?? '',


           image: json["image"] ?? '',
        transactionId: json["transaction_id"] ?? '',
        type: json["type"] ?? '',
        currencyId: json["currency_id"] ?? '',
        status: json["status"] ?? '',
        fees: json["fees"] ?? '',
        total: json["total"] ?? '',
        currencyName: json["currency_name"] ?? '',
        symbol: json["symbol"] ?? '',
        trxMode: json["trx_mode"] ?? '',
    );

   
}


