class CountryInfoModel {
  String? countryId,
      phoneNameCode,
      countryName,
      countryCode,
      status,
      isIban,
      image;

  CountryInfoModel({
    this.countryId,
    this.phoneNameCode,
    this.countryName,
    this.countryCode,
    this.status,
    this.isIban,
    this.image,
  });

  factory CountryInfoModel.fromJson(Map<String, dynamic> json) {
    return CountryInfoModel(
      countryId: json['id'] ?? '',
      phoneNameCode: json['country_code'] ?? '',
      image: json['flag'] ?? '',
      countryName: json['country_name'] ?? '',
      countryCode: json['phonecode'] ?? '',
      status: json['status'] ?? '',
      isIban: json['is_iban'] ?? '',
    );
  }
}
