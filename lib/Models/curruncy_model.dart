
class CurrunciesModel {
    CurrunciesModel({
        this.status,
        this.wallet,
    });

    int ?status;
    List<String> ?wallet;

    factory CurrunciesModel.fromJson(Map<String, dynamic> json) => CurrunciesModel(
        status: json["status"],
        wallet:json["wallet"]!=null? List<String>.from(json["wallet"].map((x) => x)):[],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "wallet": List<dynamic>.from(wallet!.map((x) => x)),
    };
}
