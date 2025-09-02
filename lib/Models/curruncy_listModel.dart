
class WalletCurruncyList {
    WalletCurruncyList({
        this.status,
        this.currency,
        this.message
    });

    int ?status;
    List<Currency>? currency;
    String ?message;

    factory WalletCurruncyList.fromJson(Map<String, dynamic> json) => WalletCurruncyList(
        status: json["status"],
        message: json['message'] ??'',
        currency: json["currency"] == null ? [] : List<Currency>.from(json["currency"].map((x) => Currency.fromJson(x))),
    );

}

class Currency {
    Currency({
        this.currecnyName,
        this.image,
    });

    String ?currecnyName;
    String ?image;

    factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        currecnyName: json["currecny_name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "currecny_name": currecnyName,
        "image": image,
    };
}
