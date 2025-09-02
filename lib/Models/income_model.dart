// To parse this JSON data, do
//
//     final incomeModel = incomeModelFromJson(jsonString);

import 'dart:convert';

IncomeModel incomeModelFromJson(String str) => IncomeModel.fromJson(json.decode(str));

String incomeModelToJson(IncomeModel data) => json.encode(data.toJson());

class IncomeModel {
    int ?status;
    List<String> ? incomeSource;

    IncomeModel({
        this.status,
        this.incomeSource,
    });

    factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
        status: json["status"],
        incomeSource: List<String>.from(json["income_source"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "income_source": List<dynamic>.from(incomeSource!.map((x) => x)),
    };
}
