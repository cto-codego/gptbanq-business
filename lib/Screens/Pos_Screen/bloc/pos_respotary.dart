import 'dart:convert';

import 'package:gptbanqbusiness/Models/Card_details_model.dart';
import 'package:gptbanqbusiness/Models/pos/check_pos_module_model.dart';
import 'package:gptbanqbusiness/Models/pos/coin_list_model.dart';
import 'package:gptbanqbusiness/Models/pos/crypto_gateway_currency_list_model.dart';
import 'package:gptbanqbusiness/Models/pos/crypto_pos_list_model.dart';
import 'package:gptbanqbusiness/Models/pos/remote_payment_model.dart';
import 'package:gptbanqbusiness/Models/pos/store_transaction_log_model.dart';
import 'package:gptbanqbusiness/Models/pos_status_model.dart';
import 'package:gptbanqbusiness/Models/posfees_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/terminal_models.dart';
import 'package:gptbanqbusiness/Models/terminal_trx_model.dart';
import 'package:gptbanqbusiness/Models/trx_model.dart';
import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../Models/pos/create_qr_model.dart';
import '../../../Models/pos/crypto_order_cancel_model.dart';
import '../../../Models/pos/get_crypto_transaction_info_model.dart';

class PosRespo {
  Future checkpos() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointCheckpos);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return PosstatusModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future Requestpos() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointRequestpos);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return StatusModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future terminadevices() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointTerminaldevices);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return TerminalDevicesmodel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future gettransactions({String? tid, date, int? page}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "tid": tid,
        "transaction_date": date,
        "page": page
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointTerminaltrx);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Trxmodel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future getlog({String? tid, date, status, int? page}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "tid": tid,
        "transaction_date": date,
        "page": page,
        "status": status
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointTerminallog);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Trxlogmodel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future posplan() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointposplan);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return PosFeesModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future checkPosModule() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.checkPosModule);

      print("check pos module response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CheckPosModuleModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cryptoPosList() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cryptoCheckList);

      print("crypto pos response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CryptoPosListModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future createCryptoStore({required String label, required String currency}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "label": label,
        "currency": currency,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.createCryptoStore);

      print("create crypto store response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return StatusModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future coinList() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.coinList);

      print("create crypto store response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return CoinListModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future createQr(
      {required String symbol, amount, storeId, type, String? email}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "symbol": symbol,
        "amount": amount,
        "storeId": storeId,
        "type": type,
        "email": email ?? "",
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.createQr);

      print("create Qr response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CreateQrModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future remotePayment(
      {required String reason, amount, storeId, type, email}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "payment_reason": reason,
        "amount": amount,
        "storeId": storeId,
        "type": 'remote',
        "email": email,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.remotePayment);

      debugPrint("Remote Payment response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return RemotePaymentModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future getCryptoTransactionInfo({required String uniqueId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "unique_id": uniqueId,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.getCryptoTransactionInfo);

      print("get crypto transaction info response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return GetCryptoTransactionInfoModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cryptoOrderCancel({required String uniqueId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "unique_id": uniqueId,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cryptoOrderCancel);

      print("crypto order cancel response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CryptoOrderCancelModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future storeTransactionLogs({required String storeId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "storeId": storeId,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.storeTransactionLogs);

      print("store transaction logs response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StoreTransactionLogModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future transactionDetails({required String uniqueId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "unique_id": uniqueId,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.transactionDetails);

      print("store transaction logs response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StoreTransactionLogModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cryptoGatewayCurrencyList() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cryptoGatewayCurrencyList);

      print("store transaction logs response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return CryptoGatewayCurrencyListModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
