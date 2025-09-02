// To parse this JSON data, do
//
//     final verifypinmodel = verifypinmodelFromJson(jsonString);

import 'dart:convert';

Verifypinmodel verifypinmodelFromJson(String str) => Verifypinmodel.fromJson(json.decode(str));


class Verifypinmodel {
    int ?status;
    String ?token;
    String ?name;
    String ?profilpic;
    String ?accountType;
    String ? errors;

    Verifypinmodel({
        this.status,
        this.token,
        this.name,
        this.profilpic,
        this.accountType,
        this.errors
    });

    factory Verifypinmodel.fromJson(Map<String, dynamic> json) => Verifypinmodel(
        status: json["status"],
        token: json["token"] ?? '',
        name: json["name"] ?? '',
        profilpic: json["profilpic"] ?? '',
        accountType: json["account_type"] ?? '',
        errors: json["errors"] ?? ''
    );

  
}
