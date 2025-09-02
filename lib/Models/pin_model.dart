// To parse this JSON data, do
//
//     final folderModel = folderModelFromJson(jsonString);

import 'dart:convert';

PinModel folderModelFromJson(String str) => PinModel.fromJson(json.decode(str));


class PinModel {
    int ? status;
    List<String> ? uniqueid;
    String ? message ;

    PinModel({
        this.status,
        this.uniqueid,
        this.message,
    });

    factory PinModel.fromJson(Map<String, dynamic> json) => PinModel(
        status: json["status"],
        message: json['message'] ?? '',
        uniqueid: List<String>.from(json["uniqueid"].map((x) => x)),
    );

  
}
