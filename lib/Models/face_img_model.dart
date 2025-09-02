// To parse this JSON data, do
//
//     final faceimagemodel = faceimagemodelFromJson(jsonString);

import 'dart:convert';

Faceimagemodel faceimagemodelFromJson(String str) => Faceimagemodel.fromJson(json.decode(str));

String faceimagemodelToJson(Faceimagemodel data) => json.encode(data.toJson());

class Faceimagemodel {
    int ? status;
    String ? img;

    Faceimagemodel({
        this.status,
        this.img,
    });

    factory Faceimagemodel.fromJson(Map<String, dynamic> json) => Faceimagemodel(
        status: json["status"],
        img: json["img"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "img": img,
    };
}
