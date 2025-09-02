import 'dart:convert';

import 'package:gptbanqbusiness/Models/Coin_qr_model.dart';
import 'package:gptbanqbusiness/Models/Crypto_coins_model.dart';
import 'package:gptbanqbusiness/Models/coin_details_model.dart';
import 'package:gptbanqbusiness/Models/convert_preview_model.dart';
import 'package:gptbanqbusiness/Models/crypto/stake_period_model.dart';
import 'package:gptbanqbusiness/Models/crypto/stake_profit_log.dart';
import 'package:gptbanqbusiness/Models/crypto/stake_stop_model.dart';
import 'package:gptbanqbusiness/Models/networks_token.dart';
import 'package:gptbanqbusiness/Models/networktype.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../Models/crypto/eur_withdraw_model.dart';
import '../../../Models/crypto/iban_deposit_eur_to_crypto_cancel_model.dart';
import '../../../Models/crypto/iban_deposit_eur_to_crypto_model.dart';
import '../../../Models/crypto/new_stake_request_model.dart';
import '../../../Models/crypto/stake_confirm_model.dart';
import '../../../Models/crypto/stake_custom_period_model.dart';
import '../../../Models/crypto/stake_fee_balance_model.dart';
import '../../../Models/crypto/stake_order_model.dart';
import '../../../Models/crypto/stake_overview_model.dart';
import '../../../Models/iban_list/iban_list.dart';
import '../../../Models/stake/iban_get_custom_account_model.dart';

class CryptoRespo {
  Future fetchcoins() async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();
    debugPrint(userId.toString());

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
      };

      debugPrint("set bodyData".toString());
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointCryptooins);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");
      debugPrint(jsonResponse['coin'][0]['trx']);

      Coins dashboardModel = Coins.fromJson(jsonResponse);
      // await fetchSidebarMenuData();
      return dashboardModel;
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

  Future<SendNetwork> networkfun({String? symbol}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "symbol": symbol
      };
      debugPrint(bodyData.toString());

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointNetwork);

      debugPrint("network response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      SendNetwork statusModel = SendNetwork.fromJson(jsonResponse);

      return statusModel;
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

  Future generaNetworkstoken({String? symbol}) async {
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
      };

      debugPrint(bodyData.toString());

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointGenerateqr);

      debugPrint(" response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      Tokennetworks statusModel = Tokennetworks.fromJson(jsonResponse);

      return statusModel;
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

  Future<StatusModel> sendCoin(
      {String? currencyId,
      String? amount,
      String? address,
      String? memo,
      String? network}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      debugPrint(currencyId.toString());

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "symbol": currencyId,
        "amount": amount,
        'receiver_address': address,
        'network': network,
        'memo': memo
      };

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointSendTransaction);

      debugPrint("sendCoin response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      StatusModel statusModel = StatusModel.fromJson(jsonResponse);

      return statusModel;
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

  Future Confirmconvert(
      {String? base_coin_symbol,
      String? from_symbol,
      String? to_symbol,
      String? type,
      String? amount}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "base_coin_symbol": base_coin_symbol,
        'from_symbol': from_symbol,
        'to_symbol': to_symbol,
        'amount': amount,
        "type": type
      };
      debugPrint("bodey : $bodyData");

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointconfirmexchange);
      debugPrint("response convert : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      StatusModel convertdata = StatusModel.fromJson(jsonResponse);

      return convertdata;
    } catch (e) {
      debugPrint('recive error $e');
    }
  }

  Future approveEurotocrypto({String? uniqueId, String? completed}) async {
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
        "status": completed,
      };

      debugPrint("approveBrowserLogin bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveeurotocrypto);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return IbanDepositEurToCryptoCancelModel.fromJson(jsonResponse);
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

  Future<StatusModel> approveTransaction(
      {String? uniqueId, String? completed}) async {
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
        "status": completed,
      };

      debugPrint("approveBrowserLogin bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveTransaction);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
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

  Future<StatusModel> approvmovewalletsfun(
      {String? uniqueId, String? completed}) async {
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
        "status": completed,
      };

      debugPrint("ApproveVirtualCarLoadEvent bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointconfirmmovewallet);

      debugPrint("ApproveVirtualCarLoadEvent response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
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

  Future approveEurotoiban({String? uniqueId, String? completed}) async {
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
        "status": completed,
      };

      debugPrint("approveBrowserLogin bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveeurotoiban);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return IbanDepositEurToCryptoCancelModel.fromJson(jsonResponse);
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

  Future Movetoiban({String? amount, ibanid}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'amount': amount,
        'iban_id': ibanid,
      };

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointMoveeurotoiban);
      debugPrint("response convert : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return EurWithdrawModel.fromJson(jsonResponse);
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future MoveEurotocrypto({String? amount, ibanid}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'amount': amount,
        'iban_id': ibanid
      };

      debugPrint("body : $bodyData");

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointeurotocrypto);
      debugPrint("response convert : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      // IbanDepositEurToCryptoModel convertData = IbanDepositEurToCryptoModel.fromJson(jsonResponse);

      return IbanDepositEurToCryptoModel.fromJson(jsonResponse);
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future generateaddress({String? symbol}) async {
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
      };

      debugPrint(bodyData.toString());

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointGenerateqr);

      debugPrint("sendCoin response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      CoinQrcode statusModel = CoinQrcode.fromJson(jsonResponse);

      return statusModel;
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

  Future convertPreview(
      {String? basesymbol, String? from, String? to, String? amount}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "base_coin_symbol": basesymbol,
        'from_coin': from,
        "to_coin": to,
        "amount": amount
      };

      debugPrint(bodyData.toString());

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointcryptoPreview);

      debugPrint("response convert : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      ConvertModel euromoveModel = ConvertModel.fromJson(jsonResponse);

      return euromoveModel;
    } catch (e) {
      debugPrint('recive error $e');
    }
  }

  Future getcoindetails({String? symbol}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'symbol': symbol
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointCoindetails);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CoindetailsModel.fromJson(jsonResponse);
      }

      // CoindetailsModel dashboardModel = CoindetailsModel.fromJson(jsonResponse);
      // await fetchSidebarMenuData();
      // return dashboardModel;
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

  Future getStakeOverview({String? symbol}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'symbol': symbol
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeOverview);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      // StakeOverviewModel stakeOverviewModel = StakeOverviewModel.fromJson(jsonResponse);
      // await fetchSidebarMenuData();
      // return stakeOverviewModel;

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StakeOverviewModel.fromJson(jsonResponse);
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

  Future getStakeProfitLog({String? orderId}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'order_id': orderId
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeProfitLog);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      // StakeProfitLogModel stakeProfitLogModel = StakeProfitLogModel.fromJson(jsonResponse);
      // // await fetchSidebarMenuData();
      // return stakeProfitLogModel;

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StakeProfitLogModel.fromJson(jsonResponse);
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

  Future getStakeStop({String? orderId}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'order_id': orderId
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeStop);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      // StakeStopModel stakeStopModel = StakeStopModel.fromJson(jsonResponse);
      // // await fetchSidebarMenuData();
      // return stakeStopModel;

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StakeStopModel.fromJson(jsonResponse);
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

  Future getStakeFee({String? symbol}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'coin': symbol,
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeFeeBalance);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StakeFeeBalanceModel.fromJson(jsonResponse);
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

  Future getStakeOrder({String? symbol, amount}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'coin': symbol,
        'amount': amount,
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeOrder);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      // StakeOrderModel stakeOrderModel = StakeOrderModel.fromJson(jsonResponse);
      // // await fetchSidebarMenuData();
      // return stakeOrderModel;

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StakeOrderModel.fromJson(jsonResponse);
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

  Future getStakeOrderConfirm({String? orderId}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'order_id': orderId
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeConfirm);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      // StakeConfirmModel stakeConfirmModel =
      //     StakeConfirmModel.fromJson(jsonResponse);
      // // await fetchSidebarMenuData();
      // return stakeConfirmModel;

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StakeConfirmModel.fromJson(jsonResponse);
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

  Future ibanlist() async {
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

      print("allWallet bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointIbanlist);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return IbanlistModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future newStakeRequest(
      {String? symbol, amount, period, isCustom, ibanId}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'coin': symbol,
        'amount': amount,
        'period': period,
        'is_custom': isCustom,
        'iban_id': ibanId,
      };

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeRequest);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      return NewStakeRequestModel.fromJson(jsonResponse);
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

  Future getStakePeriod() async {
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

      debugPrint("set bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.stakeCustomPeriod);

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint("response2 : $response");

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return StakeCustomPeriodModel.fromJson(jsonResponse);
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
}
