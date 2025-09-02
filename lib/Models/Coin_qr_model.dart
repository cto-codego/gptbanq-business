
class CoinQrcode {
    CoinQrcode({
         this.status,
         this.currencySymbol,
         this.name,
         this.image,
         this.networkType,
         this.address,
         this.qrcode,
         this.message
    });

    int ?status;
    String ?currencySymbol;
    String ?name;
    String ?image;
    String ?networkType;
    String ?address;
    String ?qrcode;
    String ?message;

    factory CoinQrcode.fromJson(Map<String, dynamic> json) => CoinQrcode(
        status: json["status"] ?? '',
        currencySymbol: json["currency_symbol"]?? '',
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        networkType: json["network_type"] ?? '',
        address: json["address"] ?? '',
        qrcode: json["qrcode"] ?? '',
        message: json["message"] ?? ''
    );

   
}