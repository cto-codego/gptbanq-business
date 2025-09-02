class BeneficiaryCountryInfo {
  String ? id, countryCode, countryName, phoneCode, status, isIban;

  BeneficiaryCountryInfo({
    this.id,
    this.countryCode,
    this.countryName,
    this.phoneCode,
    this.status,
    this.isIban,
  });

  factory BeneficiaryCountryInfo.fromJson(Map<String, dynamic> json) {
    return BeneficiaryCountryInfo(
      id: json['id'] ?? '',
      countryCode: json['country_code'] ?? '',
      countryName: json['country_name'] ?? '',
      phoneCode: json['phonecode'] ?? '',
      status: json['status'] ?? '',
      isIban: json['is_iban'] ?? '',
    );
  }
}
