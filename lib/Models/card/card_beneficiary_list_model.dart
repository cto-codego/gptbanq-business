import 'dart:convert';

CardBeneficiaryListModel cardBeneficiaryListModelFromJson(String str) =>
    CardBeneficiaryListModel.fromJson(json.decode(str));

String cardBeneficiaryListModelToJson(CardBeneficiaryListModel data) =>
    json.encode(data.toJson());

class CardBeneficiaryListModel {
  int? status;
  List<Datum>? data;

  CardBeneficiaryListModel({
    this.status,
    this.data,
  });

  factory CardBeneficiaryListModel.fromJson(Map<String, dynamic> json) =>
      CardBeneficiaryListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? cbeneficaryId;
  String? name;
  String? card;

  Datum({
    this.cbeneficaryId,
    this.name,
    this.card,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        cbeneficaryId: json["cbeneficary_id"],
        name: json["name"],
        card: json["card"],
      );

  Map<String, dynamic> toJson() => {
        "cbeneficary_id": cbeneficaryId,
        "name": name,
        "card": card,
      };
}
