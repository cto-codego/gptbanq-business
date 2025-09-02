// To parse this JSON data, do
//
//     final terminalDevicesmodel = terminalDevicesmodelFromJson(jsonString);

import 'dart:convert';

TerminalDevicesmodel terminalDevicesmodelFromJson(String str) =>
    TerminalDevicesmodel.fromJson(json.decode(str));

String terminalDevicesmodelToJson(TerminalDevicesmodel data) =>
    json.encode(data.toJson());

class TerminalDevicesmodel {
  int? status;
  List<Termial>? termial;

  TerminalDevicesmodel({
    this.status,
    this.termial,
  });

  factory TerminalDevicesmodel.fromJson(Map<String, dynamic> json) =>
      TerminalDevicesmodel(
        status: json["status"],
        termial:
            List<Termial>.from(json["termial"].map((x) => Termial.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "termial": List<dynamic>.from(termial!.map((x) => x.toJson())),
      };
}

class Termial {
  String? tid;
  String? leagalName;

  Termial({
    this.tid,
    this.leagalName,
  });

  factory Termial.fromJson(Map<String, dynamic> json) => Termial(
        tid: json["tid"],
        leagalName: json["leagal_name"],
      );

  Map<String, dynamic> toJson() => {
        "tid": tid,
        "leagal_name": leagalName,
      };
}
