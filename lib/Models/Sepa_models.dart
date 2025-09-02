// To parse this JSON data, do
//
//     final sepatypesmodel = sepatypesmodelFromJson(jsonString);

import 'dart:convert';

Sepatypesmodel sepatypesmodelFromJson(String str) => Sepatypesmodel.fromJson(json.decode(str));


class Sepatypesmodel {
    Types ? types;
    int  ? status;

    Sepatypesmodel({
        this.types,
        this.status,
    });

    factory Sepatypesmodel.fromJson(Map<String, dynamic> json) => Sepatypesmodel(
        types: Types.fromJson(json["types"]),
        status: json["status"],
    );

  
}

class Types {
    String ? sepa;
    String  ? instant;

    Types({
        this.sepa,
        this.instant,
    });

    factory Types.fromJson(Map<String, dynamic> json) => Types(
        sepa: json["sepa"] ?? '',
        instant: json["instant"] ?? '',
    );

 
}
