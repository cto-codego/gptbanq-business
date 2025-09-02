class SourceFund {
  int? status;
  List<SoruceFund>? soruceFund;

  SourceFund({
    this.status,
    this.soruceFund,
  });

  factory SourceFund.fromJson(Map<String, dynamic> json) => SourceFund(
        status: json["status"],
        soruceFund: List<SoruceFund>.from(
            json["soruceFund"].map((x) => SoruceFund.fromJson(x))),
      );
}

class SoruceFund {
  String? type;
  String? showmsg;

  SoruceFund({
    this.type,
    this.showmsg,
  });

  factory SoruceFund.fromJson(Map<String, dynamic> json) => SoruceFund(
        type: json["type"],
        showmsg: json["showmsg"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "showmsg": showmsg,
      };
}
