import 'dart:convert';

import 'package:gptbanqbusiness/Models/Card_details_model.dart';
import 'package:gptbanqbusiness/Models/Dashboard_model.dart';
import 'package:gptbanqbusiness/Models/application.dart';
import 'package:gptbanqbusiness/Models/card/card_active_model.dart';
import 'package:gptbanqbusiness/Models/card/card_beneficiary_list_model.dart';
import 'package:gptbanqbusiness/Models/card/card_block_unblock_model.dart';
import 'package:gptbanqbusiness/Models/card/card_details_model.dart';
import 'package:gptbanqbusiness/Models/card/card_iban_list_model.dart';
import 'package:gptbanqbusiness/Models/card/card_order_confirm_model.dart';
import 'package:gptbanqbusiness/Models/card/card_order_type_model.dart';
import 'package:gptbanqbusiness/Models/card/card_replace_model.dart';
import 'package:gptbanqbusiness/Models/card/card_settings_model.dart';
import 'package:gptbanqbusiness/Models/card/card_to_card_transfer_fee_model.dart';
import 'package:gptbanqbusiness/Models/card/card_topup_confirm_model.dart';
import 'package:gptbanqbusiness/Models/card/card_topup_fee_model.dart';
import 'package:gptbanqbusiness/Models/card/card_type_model.dart';
import 'package:gptbanqbusiness/Models/card/delete_card_beneficiary_model.dart';
import 'package:gptbanqbusiness/Models/card_ordermodel.dart';
import 'package:gptbanqbusiness/Models/dashboard/create_iban_list_model.dart';
import 'package:gptbanqbusiness/Models/dashboard/deposit_dashboard_model.dart';
import 'package:gptbanqbusiness/Models/dashboard/swift_deposit_model.dart';
import 'package:gptbanqbusiness/Models/debit_card_model.dart';
import 'package:gptbanqbusiness/Models/debitcardinfo_model.dart';
import 'package:gptbanqbusiness/Models/gift_card/gift_card_delete_model.dart';
import 'package:gptbanqbusiness/Models/gift_card/gift_card_details_model.dart';
import 'package:gptbanqbusiness/Models/gift_card/gift_card_get_fee_type_model.dart';
import 'package:gptbanqbusiness/Models/gift_card/gift_card_share_model.dart';
import 'package:gptbanqbusiness/Models/pdf_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/transaction_approved_model.dart';
import 'package:gptbanqbusiness/Models/transactiondetailsModel.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../Models/beneficiary/swift_add_beneficiary_model.dart';
import '../../../Models/card/card_iban_get_custom_account_model.dart';
import '../../../Models/card/card_list_model.dart';
import '../../../Models/card/card_order_details_model.dart';
import '../../../Models/convert/convert_currency_list_model.dart';
import '../../../Models/dashboard/create_iban_list_model.dart';
import '../../../Models/dashboard/iban_currency_model.dart';
import '../../../Models/dashboard/iban_kyc_check_model.dart';
import '../../../Models/dashboard/no_response_model.dart';
import '../../../Models/dashboard/terms_pdf_model.dart';
import '../../../Models/dashboard/transaction_list_model.dart';
import '../../../Models/gift_card/buy_gift_card_confirm_model.dart';
import '../../../Models/gift_card/gift_card_get_fee_data_model.dart';
import '../../../Models/gift_card/gift_card_list_model.dart';
import '../../../Models/iban_list/iban_list.dart';
import '../../../Models/trx_biometric_confirmation_notifications_model.dart';
import '../../../Models/wallet_transfer/wallet_transfer_iban_list_model.dart';

class DashboardRespotary {
  Future getdashboard() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String ibanId = await UserDataManager().getDashboardIban();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "iban_id": ibanId
      };

      debugPrint("allWallet bodyData");
      debugPrint(bodyData.toString());

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointGetallwallet);

      debugPrint("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return DashboardModel.fromJson(jsonResponse);
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

  Future<StatusModel> approveBrowserLogin(
      {String? uniqueId, int? loginStatus}) async {
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
        "status": loginStatus,
      };

      debugPrint("approveBrowserLogin bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveBrowserLogin);

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

  // Future<UpdateModel> checkupdatefun(
  //     {String? uniqueId, int? loginStatus}) async {
  //   try {
  //     String userId = await UserDataManager().getUserId();
  //     String token = await UserDataManager().getToken();
  //
  //     Map<String, dynamic> bodyData = {
  //       "authkey": AppConfig.authKey,
  //       "secretkey": AppConfig.secretKey,
  //       "whitelablel": AppConfig.whiteLabel,
  //       "user_id": userId,
  //       "token": token,
  //     };
  //
  //     debugPrint("approveBrowserLogin bodyData");
  //     debugPrint(bodyData.toString());
  //     Response? response = await NetworkManager().callApi(
  //         method: HttpMethod.Post,
  //         body: bodyData,
  //         urlEndPoint: AppConfig.endPointcheckappversion);
  //
  //     debugPrint("response : $response");
  //     Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
  //     return UpdateModel.fromJson(jsonResponse);
  //   } on ApiException catch (e) {
  //     debugPrint(e.toString());
  //     // ignore: use_rethrow_when_possible
  //     throw (e);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     // ignore: use_rethrow_when_possible
  //     throw (e);
  //   }
  // }

  Future Sendemail({String? email, iban}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "email": email,
        "iban_id": iban
      };

      debugPrint("allWallet bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointSharemail);

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

  Future closenotify({String? id}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "noti_id": id,
      };

      debugPrint("allWallet bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointclosenotifcation);

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

  Future ordercard({String? type}) async {
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

      debugPrint("allWallet bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointordercard);

      debugPrint("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return DebitFees.fromJson(jsonResponse);
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

  Future debitcardinform({String? cardId, String? pin}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "card_id": cardId,
        "pin": pin
      };
      print("fetchCardDetail bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointgetcarddetails);

      print("response Debit card : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Debitcardinfo.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<StatusModel> updateCardSetting({
    String? cardId,
    String? settingName,
    String? settingValue,
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
        "card_id": cardId,
        "setting_name": settingName,
        "setting_value": settingValue,
      };

      print("fetchCardDetail bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointUpdateCardSettings);

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

  Future movebalance({String? amount, ibanid}) async {
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
        "type": "debit",
        "iban_id": ibanid
      };

      print(bodyData);

      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointMovebalancetodebit);

      print("move wallet to debit : $response");
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

      print("ApproveVirtualCarLoadEvent bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointconfirmmovewallet);

      print("ApproveVirtualCarLoadEvent response : $response");
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

  Future checkcard() async {
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

      print("fetchCardDetail bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointIbancheckcard);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Cardordermodel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<StatusModel> resetCardPin({
    String? cardId,
    String? cardPin,
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
        "card_id": cardId,
        "card_pin": cardPin,
      };

      print("fetchCardDetail bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointResetCardPin);

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

  Future DebitCarddetails() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "card_id": '',
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointCreditcarddetails);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CardDetails.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future transactiondetails({String? id}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "unique_id": id,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointtrxdetails);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Transactiondetailsmodel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future approveTransaction({String? uniqueId, String? completed}) async {
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

      print("approveBrowserLogin bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveTransaction);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return TransactionApprovedModel.fromJson(jsonResponse);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<StatusModel> approveEurotoiban(
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

      print("approveBrowserLogin bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveeurotoiban);

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

  Future<StatusModel> approveEurotocrypto(
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

      print("approveBrowserLogin bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveeurotocrypto);

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

  Future Dawnloadinvoice({String? id}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "unique_id": id,
      };

      print(" bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointdawnloainvoice);

      print("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Pdfmodel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future debitCardactivate({String? cardnumber, String? activate}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "card_number": cardnumber,
        "active_code": activate
      };

      print("prepaidCardFee bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointdebitCardActivatenew);

      print("prepaidCardFeeresponse : $response");
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

  Future<StatusModel> activatedeitCard(
      {String? cardNumber, String? cvv, String? mm, String? yy}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "card_number": cardNumber,
        "cvv": cvv,
        "mm": mm,
        "yy": yy,
      };

      print("activatePrepaidCard bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointdebitcard_activate);

      print("activatePrepaidCard response : $response");
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

  Future debitcardfees({String? type}) async {
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
          urlEndPoint: AppConfig.endPointdebitcard_fees);

      print("Debit card fees : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return DebitFees.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<StatusModel> deitCardOrder() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "account_id": Application.accountId,
      };

      print("prepaidCardOrder bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
        method: HttpMethod.Post,
        body: bodyData,
        urlEndPoint: AppConfig.endPointdebitcard_order,
      );

      print("prepaidCardOrder : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response?.data);
      return StatusModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  //gift card api
  Future giftCardList() async {
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

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.giftCardList);

      debugPrint("Debit card fees : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return GiftCardListModel.fromJson(jsonResponse);
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

  Future giftCardGetFeeType() async {
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

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.giftCardGetFeeType);

      debugPrint("Debit card fees : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        UserDataManager().giftCardSave(jsonResponse["cardType"][0] ?? "");
        UserDataManager()
            .giftCardIbanSave(jsonResponse["iban"][0]["iban_id"] ?? "");

        print("${jsonResponse["cardType"][0]}");
        print("${jsonResponse["iban"][0]["iban_id"]}");
        return GiftCardGetFeeTypeModel.fromJson(jsonResponse);
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

  Future giftCardGetFeeData({required String amount}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String card = await UserDataManager().getGiftCard();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": card,
        "amount": amount,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.giftCardGetFeeData);

      debugPrint("Debit card fees : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return GiftCardGetFeeDataModel.fromJson(jsonResponse);
      }
      // return GiftCardGetFeeDataModel.fromJson(jsonResponse);
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

  Future giftCardOrderConfirm() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String card = await UserDataManager().getGiftCard();
      String iban = await UserDataManager().getGiftCardIban();
      String amount = await UserDataManager().getGiftCardAmount();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": card,
        "iban_id": iban,
        "amount": amount,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.giftCardOrderConfirm);

      debugPrint("Debit card fees : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      return BuyGiftCardConfirmModel.fromJson(jsonResponse);
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

  Future giftCardDetails() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getGiftCardIban();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "card_id": cardId,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.giftCardDetails);

      debugPrint("Debit card fees : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return GiftCardDetailsModel.fromJson(jsonResponse);
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

  Future giftCardDelete() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getGiftCardDeleteCardId();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "card_id": cardId,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.giftCardDelete);

      debugPrint("Debit card fees : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      return GiftCardDeleteModel.fromJson(jsonResponse);
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

  Future giftCardShare() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getGiftCardDeleteCardId();
      String email = await UserDataManager().getGiftCardShareEmail();
      String name = await UserDataManager().getGiftCardShareName();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "card_id": cardId,
        "email": email,
        "name": name,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.giftCardShare);

      debugPrint("Debit card fees : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      return GiftCardShareModel.fromJson(jsonResponse);
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

  Future cardList() async {
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

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardList);

      debugPrint("card List : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardListModel.fromJson(jsonResponse);
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

  Future cardOrderType() async {
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

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardOrderType);

      debugPrint("card type : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardOrderTypeModel.fromJson(jsonResponse);
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

  Future cardType() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardType = await UserDataManager().getCardType();
      String type = await UserDataManager().getCard();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": type,
        "cardType": cardType,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardType);

      debugPrint("card type : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        UserDataManager().userAddressSave(jsonResponse["address"].toString());
        UserDataManager().userCitySave(jsonResponse["postalcode"].toString());
        UserDataManager().userPostalCodeSave(jsonResponse["city"].toString());
        UserDataManager().userCountySave(
            jsonResponse["shipping"]["country"][0]["country_code"].toString());

        return CardTypeModel.fromJson(jsonResponse);
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

  Future cardOrderDetails() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardType = await UserDataManager().getCardType();
      String type = await UserDataManager().getCard();
      String country = await UserDataManager().getUserCountry();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": type,
        "cardType": cardType,
        "service": "order",
        "country": country,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardServiceFee);

      debugPrint("card details : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        UserDataManager()
            .cardShippingCostSave(jsonResponse["shipping_cost"].toString());
        return CardOderDetailsModel.fromJson(jsonResponse);
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

  Future cardOrderConfirm({required String ibanId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String type = await UserDataManager().getCard();
      String cardType = await UserDataManager().getCardType();
      String country = await UserDataManager().getUserCountry();
      String address = await UserDataManager().getUserAddress();
      String city = await UserDataManager().getUserCity();
      String postalCode = await UserDataManager().getUserPostalCode();
      String shippingCost = await UserDataManager().getCardShippingCost();
      String cardHolder = await UserDataManager().getCardHolder();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "service": "order",
        "type": type,
        "cardType": cardType,
        "iban_id": ibanId,
        "card_holder": cardHolder,
        "shipping_cost": shippingCost,
        "address": address,
        "city": city,
        "country": country,
        "zipcode": postalCode,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardOrderConfirm);

      debugPrint("card order confirm : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardOrderConfirmModel.fromJson(jsonResponse);
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

  Future cardDetails() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getCardId();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cid": cardId,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardDetails);

      debugPrint("card details : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        // Decode the JSON string
        Map<String, dynamic> data = jsonResponse;

        String dailyLimit = data['card']['card_setting']['daily_limit'];
        String contactlessLimit =
            data['card']['card_setting']['contactless_limit'];
        String onlineValue = data['card']['card_setting']['online'];
        String contactlessValue = data['card']['card_setting']['contactless'];
        String recurringValue = data['card']['card_setting']['recurring'];
        String pinBlockUnblock = data['card']['card_setting']['atml_block'];
        String senderId = data['card']['cid'];

        UserDataManager().cardDailyLimitSave(dailyLimit);
        UserDataManager().cardContactlessLimitSave(contactlessLimit);
        UserDataManager().cardOnlineSave(onlineValue);
        UserDataManager().cardContactlessSave(contactlessValue);
        UserDataManager().cardRecurringSave(recurringValue);
        UserDataManager().pinBlockUnblockSave(pinBlockUnblock);
        UserDataManager().cardToCardTransferSenderIdSave(senderId);

        return UserCardDetailsModel.fromJson(jsonResponse);
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

  Future cardActive() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getCardId();
      String cardNumber = await UserDataManager().getActiveCardNumber();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cid": cardId,
        "cardnumber": cardNumber,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardActiveDetails);

      debugPrint("card active : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardActiveModel.fromJson(jsonResponse);
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

  Future cardSettings() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getCardId();
      String dailyLimit = await UserDataManager().getCardDailyLimit();
      String contactlessLimit =
          await UserDataManager().getCardContactlessLimit();
      String online = await UserDataManager().getCardOnline();
      String contactless = await UserDataManager().getCardContactless();
      String recurring = await UserDataManager().getCardRecurring();
      String pinBlock = await UserDataManager().getPinBlockUnblock();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cid": cardId,
        "daily_limit": dailyLimit,
        "contactless_limit": contactlessLimit,
        "online": online,
        "contactless": contactless,
        "recurring": recurring,
        "atml_block": pinBlock,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardSetting);

      debugPrint("card Settings : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardSettingsModel.fromJson(jsonResponse);
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

  Future cardBlockUnblock() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getCardId();
      String blockUnblock = await UserDataManager().getCardBlockUnblockStatus();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cid": cardId,
        "status": blockUnblock,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardBlockUnblock);

      debugPrint("card Block Unblock : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardBlockUnblockModel.fromJson(jsonResponse);
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

  Future cardReplace() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getCardId();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cid": cardId
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardReplace);

      debugPrint("card Replace : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardReplaceModel.fromJson(jsonResponse);
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

  Future cardIbanList() async {
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

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardIbanList);

      debugPrint("card Iban List : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        String selectedIban = jsonResponse["ibaninfo"][0]["iban_id"];
        UserDataManager().cardIbanSelectSave(selectedIban);
        return CardIbanListModel.fromJson(jsonResponse);
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

  Future cardTopupFee({required String ibanId}) async {
    try {
      print("iban id: $ibanId");
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getCardId();
      String amount = await UserDataManager().getPrepaidCardAmount();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cid": cardId,
        "amount": amount,
        "iban_id": ibanId
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardTopupAmount);

      debugPrint("cardTopupFee : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardTopUpFeeModel.fromJson(jsonResponse);
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

  Future cardTopupConfirm({required String ibanId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardId = await UserDataManager().getCardId();
      String amount = await UserDataManager().getPrepaidCardAmount();
      // String iban = await UserDataManager().getCardIbanSelected();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cid": cardId,
        "amount": amount,
        "iban_id": ibanId,
      };

      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardTopupConfirm);

      debugPrint("cardTopupConfirm : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      debugPrint(jsonResponse.toString());

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardTopUpConfirmModel.fromJson(jsonResponse);
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

  Future trxBiometricConfirmationDetails({String? uniqueId}) async {
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

      debugPrint("trx_biometric_confirmation details bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.trxPaymentDetails);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return TrxBiometricConfirmationNotificationsModel.fromJson(
            jsonResponse);
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

  Future trxBiometricConfirmOrCancel(
      {String? uniqueId, String? loginStatus}) async {
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
        "status": loginStatus,
      };

      debugPrint("trx_biometric_confirmation bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.trxPaymentConfirmOrCancel);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return TransactionApprovedModel.fromJson(jsonResponse);
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

  Future getCardBeneficiaryList({String? uniqueId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token
      };

      debugPrint("Card beneficiary List Body");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardBeneficiaryList);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardBeneficiaryListModel.fromJson(jsonResponse);
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

  Future addCardBeneficiary() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String email = await UserDataManager().getAddCardBeneficiaryEmail();
      String card = await UserDataManager().getAddCardBeneficiaryCard();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "email": email,
        "card": card,
      };

      debugPrint("Add Card beneficiary body");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.addCardBeneficiary);

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

  Future deleteCardBeneficiary() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardBeneficiaryId = await UserDataManager().getCardBeneficiaryId();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cbeneficary_id": cardBeneficiaryId,
      };

      debugPrint("delete card beneficiary bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.deleteCardBeneficiary);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return DeleteCardBeneficiaryModel.fromJson(jsonResponse);
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

  Future cardToCardTransferFees() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardBeneficiaryId = await UserDataManager().getCardBeneficiaryId();
      String amount = await UserDataManager().getCardToCardTransferAmount();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cbeneficary_id": cardBeneficiaryId,
        "amount": amount,
      };

      debugPrint("card to card transfer details bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardToCardTransferFee);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CardToCardTransferFeeModel.fromJson(jsonResponse);
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

  Future cardToCardTransferConfirm({String? uniqueId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String cardBeneficiaryId = await UserDataManager().getCardBeneficiaryId();
      String amount = await UserDataManager().getCardToCardTransferAmount();
      String senderId = await UserDataManager().getCardToCardTransferSenderId();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "cbeneficary_id": cardBeneficiaryId,
        "amount": amount,
        "sender_cid": senderId,
      };

      debugPrint("trx_biometric_confirmation details bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.cardToCardTransferConfirm);

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

  Future downloadTransactionStatement() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String ibanID = await UserDataManager().getUserIban();
      String fromDate = await UserDataManager().getFromDate();
      String toDate = await UserDataManager().getToDate();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "iban_id": ibanID,
        "from_date": fromDate,
        "to_date": toDate,
      };

      debugPrint("download transaction statement details bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.downloadTransactionStatement);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return TransactionListModel.fromJson(jsonResponse);
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
          urlEndPoint: AppConfig.endPointDashboardIbanlist);

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

  Future Createiban({String? label, currency, iban, required int isWallet}) async {
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
        "iswallet": isWallet,
        "iban": iban,
      };

      print("allWallet bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.createIban);

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

  /*get iban currency */
  Future getIbanCurrency() async {
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

      debugPrint("iban currency bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.getIbanMultipleCurrency);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return IbanCurrencyModel.fromJson(jsonResponse);
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

  Future getIbanList({required String currency}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "currency": currency,
      };

      debugPrint("iban currency bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.getIbanMultipleList);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return CreateIbanListModel.fromJson(jsonResponse);
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

  Future getibanSumSubVerified(
      {required String currency, required String iban}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "currency": currency,
        "iban": iban,
      };

      debugPrint("iban sum sub check bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.ibanCheckSumSubVerified);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return IbanKycCheckModel.fromJson(jsonResponse);
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

  Future swiftCountryList() async {
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
          urlEndPoint: AppConfig.swiftCountry);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SwiftAddBeneficiaryModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future swiftDepositData() async {
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
          urlEndPoint: AppConfig.swiftDepositData);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SwiftDepositModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future swiftTermsData(
      {required String type, required String deviceType}) async {
    try {
      String userId = await UserDataManager().getUserId();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
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

  Future depositAccountDetails({required String ibanId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "iban_id": ibanId,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.depositAccountDetails);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return DepositDashboardModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

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

  Future termsPdf() async {
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
          urlEndPoint: AppConfig.termsAndConditionApi);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return TermsPdfModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cardIbanGetCustomAccountDetails() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": "orderCard",
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.ibanGetCustomAccount);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CardIbanGetCustomAccountsModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future cardTopUpIbanGetCustomAccountDetails() async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "type": "cardTopup",
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.ibanGetCustomAccount);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CardIbanGetCustomAccountsModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future walletTransferIbanList({required String ibanId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "iban_id": ibanId,
      };

      debugPrint(" 📒📒📒 bodyData 📒📒📒");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.walletTransferIbanList);

      debugPrint("Wallet Transfer Iban List : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return WalletTransferIbanListModel.fromJson(jsonResponse);
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

  Future requestForSessionDataApi({required String uniqueId}) async {
    String userId = await UserDataManager().getUserId();
    String token = await UserDataManager().getToken();

    String sessionData = await UserDataManager().getUserDeviceInfo();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "unique_id": uniqueId,
        "sessiondata": sessionData,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.codegoRequestForSessionDataApi);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return NoResponseModel.fromJson(jsonResponse);
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
