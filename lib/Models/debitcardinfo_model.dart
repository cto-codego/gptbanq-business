





class Debitcardinfo {
    Debitcardinfo({
        this.status,
        this.cardDetails,
        this.message
    });

    int ? status;
        String? message;

    CardinfoDetails ?cardDetails;

    factory Debitcardinfo.fromJson(Map<String, dynamic> json) => Debitcardinfo(
        status: json["status"] ,
        message: json['message'] ?? '',
        cardDetails:json["card_details"]!=null? CardinfoDetails.fromJson(json["card_details"]) :CardinfoDetails()  ,
    );

    
}

class CardinfoDetails {
    CardinfoDetails({
        this.cvv,
        this.expiryDate,
        this.cardNumber,
    });

    String ?cvv;
    String ?expiryDate;
    String ?cardNumber;

    factory CardinfoDetails.fromJson(Map<String, dynamic> json) => CardinfoDetails(
        cvv: json["cvv"] ?? '',
        expiryDate: json["expiry_date"] ?? '',
        cardNumber: json["card_number"]?? "",
    );

    
}
