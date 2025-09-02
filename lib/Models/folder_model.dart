// To parse this JSON data, do
//
//     final folderModel = folderModelFromJson(jsonString);

import 'dart:convert';

FolderModel folderModelFromJson(String str) => FolderModel.fromJson(json.decode(str));


class FolderModel {
    int ? status;
    String ?folder;
    String ?message;

    FolderModel({
        this.status,
        this.folder,
        this.message,
    });

    factory FolderModel.fromJson(Map<String, dynamic> json) => FolderModel(
        status: json["status"],
        folder: json["folder"] ?? '',
        message: json["message"],
    );

  
}
