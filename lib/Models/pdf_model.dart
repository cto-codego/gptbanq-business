
class Pdfmodel {
    int ? status;
    String ? url ;

    Pdfmodel({
        this.status,
        this.url,
    });

    factory Pdfmodel.fromJson(Map<String, dynamic> json) => Pdfmodel(
        status: json["status"],
        url: json['url'] ?? '',
    );

  
}
