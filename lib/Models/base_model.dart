import 'package:gptbanqbusiness/Models/country_info_model.dart';
import 'package:gptbanqbusiness/Models/error_model.dart';

class BaseModel {
  int? statusCode;
  List<CountryInfoModel>? countriesList;
  static List<CountryInfoModel> availableCountriesList = [];
  ErrorModel? errorModel;
  BaseModel({
    this.statusCode,
    this.countriesList,
    this.errorModel,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    List<CountryInfoModel> countries = [];

    if (json['status'] == 1) {
      json['countries'].asMap().forEach((index, item) {
        countries.add(CountryInfoModel.fromJson(item));
      });

      availableCountriesList = countries;

      return BaseModel(
        statusCode: json['status'],
        countriesList: countries,
      );
    } else {
      return BaseModel(
        statusCode: json['status'],
        errorModel: ErrorModel.fromJson(json),
      );
    }
  }
}
