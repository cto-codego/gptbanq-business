import 'dart:convert';

KycDocumentTypeModel kycDocumentTypeModelFromJson(String str) =>
    KycDocumentTypeModel.fromJson(json.decode(str));

String kycDocumentTypeModelToJson(KycDocumentTypeModel data) =>
    json.encode(data.toJson());

class KycDocumentTypeModel {
  int? status;
  List<Doc>? doc;

  KycDocumentTypeModel({
    this.status,
    this.doc,
  });

  factory KycDocumentTypeModel.fromJson(Map<String, dynamic> json) =>
      KycDocumentTypeModel(
        status: json["status"],
        doc: json["doc"] == null
            ? []
            : List<Doc>.from(json["doc"]!.map((x) => Doc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "doc":
            doc == null ? [] : List<dynamic>.from(doc!.map((x) => x.toJson())),
      };
}

class Doc {
  String? type;
  String? image;

  Doc({
    this.type,
    this.image,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        type: json["type"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "image": image,
      };
}
