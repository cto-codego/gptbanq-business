import 'dart:convert';
import 'dart:math';

import 'package:gptbanqbusiness/Models/base_model.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/get_imei.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../Models/user_status/user_app_status_model.dart';

class AppRespo {
  Future<UserAppStatusModel> getUserStatus() async {
    try {
      String imei = await DeviceIMEI().creatrandom();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "imei": imei,
      };
      debugPrint("getUserStatus body : $bodyData");

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.getUserAppStatus);

      debugPrint("UserStatus response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return UserAppStatusModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      debugPrint(e.toString());
      // ignore: use_rethrow_when_possible
      throw (e);
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_rethrow_when_possible
      throw (e);
    }
  }

  Future<String> creatrandom() async {
    try {
      String imei = await UserDataManager().getImei();

      if (imei == null || imei == '') {
        final Random _random = Random.secure();

        var values = List<int>.generate(32, (i) => _random.nextInt(256));

        UserDataManager().saveImei(base64Url.encode(values));

        return base64Url.encode(values);
      } else {
        return imei;
      }
    } catch (e) {
      return '';
    }
  }

  Future<BaseModel> GetCountries() async {
    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointCountriesApi);

      debugPrint("BaseModel response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return BaseModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      debugPrint(e.toString());
      // ignore: use_rethrow_when_possible
      throw (e);
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_rethrow_when_possible
      throw (e);
    }
  }
}
