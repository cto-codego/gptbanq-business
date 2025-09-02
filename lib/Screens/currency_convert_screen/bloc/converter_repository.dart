import 'dart:convert';

import 'package:gptbanqbusiness/Models/convert/convert_confirm_model.dart';
import 'package:gptbanqbusiness/Models/convert/currency_rate_model.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';

import '../../../Models/convert/convert_currency_list_model.dart';

class ConverterRepository {
  Future getConvertCurrencyList({required String buyCurrency}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "buy_currency": buyCurrency,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.convertCurrencyList);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return ConvertCurrencyListModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future getCurrencyRate(
      {required String buyCurrency, required String sellCurrency}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "buy_iban_id": buyCurrency,
        "sell_iban_id": sellCurrency,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.currencyRate);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CurrencyRateModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future currencyConvertConfirm(
      {required String buyCurrencyId, required String sellCurrencyId, required String amount}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "buy_iban_id": buyCurrencyId,
        "sell_iban_id": sellCurrencyId,
        "amount": amount,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.currencyConvertConfirm);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return ConvertConfirmModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
