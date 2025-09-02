import 'dart:convert';

import 'package:gptbanqbusiness/Models/cdg/cdg_accounts_model.dart';
import 'package:gptbanqbusiness/Models/cdg/cdg_dashboard_model.dart';
import 'package:gptbanqbusiness/Models/cdg/cdg_device_list_model.dart';
import 'package:gptbanqbusiness/Models/cdg/cdg_profit_log_model.dart';
import 'package:gptbanqbusiness/Models/cdg/cdg_qr_code_model.dart';
import 'package:gptbanqbusiness/Models/investment/buy_master_node_model.dart';
import 'package:gptbanqbusiness/Models/investment/node_check_module_model.dart';
import 'package:gptbanqbusiness/Models/investment/node_logs_model.dart';
import 'package:gptbanqbusiness/Models/investment/node_profit_log_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../Models/stake/iban_get_custom_account_model.dart';
import '../models/cdg_stake_list_model.dart';
import '../models/cdg_stake_overview_model.dart';
import '../models/unstake_model.dart';

class InvestmentRepo {
  Future nodeCheckModule() async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      debugPrint("node module data: $bodyData");
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.nodeModule);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("node module data: $response");

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return NodeCheckModuleModel.fromJson(jsonResponse);
      }
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

  Future nodeLogs() async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      debugPrint("node module data: $bodyData");
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.nodeLogs);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("node module data: $response");

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return NodeLogsModel.fromJson(jsonResponse);
      }
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

  Future nodeProfitLogs({required String orderId}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "order_id": orderId,
      };

      debugPrint("node profit data: $bodyData");
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.nodeProfitLogs);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("node profit data: $response");

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return NodeProfitLogModel.fromJson(jsonResponse);
      }
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

  Future buyMasterNodeInfo() async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      debugPrint("node profit data: $bodyData");
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.nodeGetOrderInfo);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("node profit data: $response");

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return BuyMasterNodeModel.fromJson(jsonResponse);
      }
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

  Future orderMasterNode(
      {required int numberOfNode, required String ibanId}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "number_of_node": numberOfNode,
        "iban_id": ibanId,
      };

      debugPrint("node order data: $bodyData");
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.nodeOrder);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("node order data: $response");

      return StatusModel.fromJson(jsonResponse);
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

  Future swiftTermsData(
      {required String type, required String deviceType}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": type,
        "device_type": deviceType,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.sdkKycUdatetc);

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

  Future ibanGetCustomAccountDetails({required String type, symbol}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": type,
        "coin": symbol,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.ibanGetCustomAccount);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return IbanGetCustomAccountsModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /*CDG masternode section*/

  Future cdgDeviceList() async {
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

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgDeviceList);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgDeviceListModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgAccounts() async {
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

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgAccounts);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgAccountsModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgActive({required String type}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": type,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgAccounts);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgAccountsModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgMasternodeOrder({
    required String deviceId,
    required String numberOfNode,
    required String ibanId,
    required String country,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required String surnameOrCompany,
    required String phone,
  }) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "device_id": deviceId,
        "number_of_node": numberOfNode,
        "iban_id": ibanId,
        "address": address,
        "city": city,
        "zipcode": zipCode,
        "country": country,
        "state": state,
        "name": surnameOrCompany,
        "mobile": phone,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgOrder);

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

  Future cdgDashboard() async {
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

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgDashboard);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgDashboardModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgProfitLog({required String orderId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "order_id": orderId,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgProfitLog);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgProfitLogModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgSendInvite({required String name, required String email}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "name": name,
        "email": email,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgSendInvite);

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

  Future cdgCheckQrCode({required String serialNumber}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "serial_number": serialNumber,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgCheckQrCode);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgQrCodeModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgDeviceActive(
      {required String cdgId,
      required String iban,
      required String serialNumber}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "serial_number": serialNumber,
        "cdg_id": cdgId,
        "iban_id": iban,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgDeviceActive);

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

  Future cdgConvert({required String amount}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "amount": amount,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgConvert);

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

  Future cdgStakeList() async {
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

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgListForStakeApi);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgStakeListModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgStakeSelected({required List<String> stakeSelectedCdgId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cdg_id": stakeSelectedCdgId,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgStakeGetOverview);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CdgStakeOverviewModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cdgStakePayNow({required List<String> stakeSelectedCdgId, required int bootPercentage}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cdg_id": stakeSelectedCdgId,
        "boot_percentage": bootPercentage,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgStakePayNow);

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

  Future cdgUnStake() async {
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

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cdgUnStakeApi);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return UnStakeModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
