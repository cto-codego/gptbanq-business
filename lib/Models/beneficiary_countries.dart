import 'package:gptbanqbusiness/Models/beneficiary_country_info.dart';

class BeneficiaryCountriesModel {
  int? status;
  List<BeneficiaryCountryInfo>? beneficiaryCountriesList;
  String? message;

  BeneficiaryCountriesModel({
    this.status,
    this.beneficiaryCountriesList,
    this.message,
  });

  factory BeneficiaryCountriesModel.fromJson(Map<String, dynamic> json) {
    List<BeneficiaryCountryInfo> countries = [];

    if (json['status'] == 1) {
      json['countries'].asMap().forEach((index, item) {
        countries.add(BeneficiaryCountryInfo.fromJson(item));
      });
    }

    return BeneficiaryCountriesModel(
      status: json['status'] ?? '',
      beneficiaryCountriesList: countries,
      message: json['message'] ?? '',
    );
  }
}
