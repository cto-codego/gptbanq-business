// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    int? status;
    String? accountStatus;
    String? name;
    String? surname;
    String? email;
    String? risk;
    String? currency;
    String? iban;
    String? bic;
    String? balance;
    String? address;
    String? city;
    String? countryName;
    int? upgradePlan;
    String? profileimage;
    String? contactUs;
    String? helpFaq;
    String? planName;
    int? needShowUpgrade;
    String? planurl;
    String? bankName;
    String? bankAddress;
    String? symbol;
    String? currencyflag;
    String? paywith;
    String? cdg;
    String? cdg_message;
    int? hide_cdg_fee;
    Sof? sof;

    ProfileModel({
        this.status,
        this.accountStatus,
        this.name,
        this.surname,
        this.email,
        this.risk,
        this.currency,
        this.iban,
        this.bic,
        this.balance,
        this.address,
        this.city,
        this.countryName,
        this.upgradePlan,
        this.profileimage,
        this.planurl,
        this.contactUs,
        this.helpFaq,
        this.planName,
        this.needShowUpgrade,
        this.bankName,
        this.bankAddress,
        this.symbol,
        this.currencyflag,
        this.paywith,
        this.cdg,
        this.cdg_message,
        this.hide_cdg_fee,
        this.sof,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        accountStatus: json["account_status"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        risk: json["risk"],
        currency: json["currency"],
        iban: json["iban"],
        bic: json["bic"],
        balance: json["balance"],
        address: json["address"],
        planurl: json['plan_url'],
        city: json["city"],
        countryName: json["country_name"],
        upgradePlan: json["upgrade_plan"],
        profileimage: json["profileimage"],
        contactUs: json["contact_us"],
        helpFaq: json["help_faq"],
        bankName: json["bank_name"],
        bankAddress: json["bank_address"],
        planName: json["plan_name"] ?? '',
        needShowUpgrade: json["need_show_upgrade"],
        currencyflag: json["currencyflag"],
        symbol: json["symbol"],
        paywith: json["paywith"],
        cdg: json["cdg"],
        cdg_message: json["cdg_message"],
        hide_cdg_fee: json["hide_cdg_fee"],
        sof: json["sof"] == null ? null : Sof.fromJson(json["sof"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "account_status": accountStatus,
        "name": name,
        "surname": surname,
        "email": email,
        "risk": risk,
        "currency": currency,
        "iban": iban,
        "bic": bic,
        "balance": balance,
        "address": address,
        "city": city,
        "country_name": countryName,
        "upgrade_plan": upgradePlan,
        "profileimage": profileimage,
        "contact_us": contactUs,
        "help_faq": helpFaq,
        "bank_name": bankName,
        "bank_address": bankAddress,
        "plan_name": planName,
        "need_show_upgrade": needShowUpgrade,
        "currencyflag": currencyflag,
        "symbol": symbol,
        "paywith": paywith,
        "cdg": cdg,
        "cdg_message": cdg_message,
        "hide_cdg_fee": hide_cdg_fee,
        "sof": sof?.toJson(),
    };
}

class Sof {
    String? label;
    int? sourceOfWealth;
    String? sourceOfWealthMsg;

    Sof({
        this.label,
        this.sourceOfWealth,
        this.sourceOfWealthMsg,
    });

    factory Sof.fromJson(Map<String, dynamic> json) => Sof(
        label: json["label"],
        sourceOfWealth: json["source_of_wealth"],
        sourceOfWealthMsg: json["source_of_wealth_msg"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "source_of_wealth": sourceOfWealth,
        "source_of_wealth_msg": sourceOfWealthMsg,
    };
}