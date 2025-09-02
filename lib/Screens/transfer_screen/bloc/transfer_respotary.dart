import 'dart:convert';
import 'dart:developer';

import 'package:gptbanqbusiness/Models/Regula_model.dart';
import 'package:gptbanqbusiness/Models/Sendmone_model.dart';
import 'package:gptbanqbusiness/Models/Sepa_models.dart';
import 'package:gptbanqbusiness/Models/beneficiary/dynamic_add_beneficiary_model.dart';
import 'package:gptbanqbusiness/Models/beneficiary/dynamic_beneficiary_field_model.dart';
import 'package:gptbanqbusiness/Models/beneficiary/swift_send_money_user_model.dart';
import 'package:gptbanqbusiness/Models/binficary_model.dart';
import 'package:gptbanqbusiness/Models/push_model.dart';
import 'package:gptbanqbusiness/Models/send_money/swift_payment_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import '../../../Models/beneficiary/swift_add_beneficiary_model.dart';
import '../../../Models/iban_list/iban_list.dart';

class TransferRespo {
  Future getbinficiarylist({required String ibanId}) async {
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
          urlEndPoint: AppConfig.endPointBeneficiaryList);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return BinficaryModel.fromJson(jsonResponse);
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

  Future sepatypes() async {
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

      debugPrint(" bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointSepa);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Sepatypesmodel.fromJson(jsonResponse);
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

  Future Swipconfirm({String? id}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "unique_id": id
      };

      debugPrint(" bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointIbanpush);

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

  Future Sendmoneyfun(
      {String? reference,
      String? amount,
      String? ibanid,
      String? beneficiary,
      String? paymentoption}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "reason_payment": reference,
        "amount": amount,
        "beneficiary_id": beneficiary,
        'payment_option': paymentoption,
        'iban_id': ibanid
      };

      debugPrint(" bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointSendMoney);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SendmoneyModel.fromJson(jsonResponse);
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

  Future updateregula({String? kycid, String? match, userimage}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "kyc_request_id": kycid,
        'face_matched': match,
        'userimage': userimage
      };

      print(" bodyData");
      print(bodyData);
      log(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointIbanregula);

      log("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return RegulaModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<StatusModel> deleteBeneficiary({
    String? uniqueId,
  }) async {
    try {
      print("deleteBeneficiary formData");
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

      print(bodyData);
      Response? response = await NetworkManager().callApi(
        method: HttpMethod.Post,
        body: bodyData,
        urlEndPoint: AppConfig.endPointDeleteBeneficiary,
      );

      print("deleteBeneficiary response : $response");
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

  Future<PushModel> approveibanTransaction(
      {required String completed, lat, long, uniqueId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "is_facematch": 1,
        "unique_id": uniqueId,
        "late": lat.toString(),
        "long": long.toString(),
        "status": completed,
      };

      print("approveBrowserLogin bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveibanTransaction);

      print("response confirmpush: $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return PushModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<PushModel> approveIbanSwiftTransaction(
      {required String completed, lat, long, uniqueId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        // "is_facematch": 1,
        "unique_id": uniqueId,
        "late": lat.toString(),
        "long": long.toString(),
        // "status": completed,
      };

      print("approveBrowserLogin bodyData");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointApproveIbanSwiftTransaction);

      print("response confirmpush: $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return PushModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future senduserphoto({String? userimage}) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'User-Agent': AppConfig.userAgent, // Add your User-Agent here
      };
      var request = http.Request(
        'POST',
        Uri.parse('${AppConfig.subBaseUrl}/gptbanqbusiness/post_new'),
      );
      request.body = json.encode({"userimage": userimage});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        log(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      log(e.toString());
      throw (e);
    }
  }

  Future addbinfechary(
      {String? name,
      String? lastname,
      String? image,
      String? iban,
      String? email,
      String? type,
      String? bic,
      String? companyname}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      var request = http.MultipartRequest(
          'POST', Uri.parse("${AppConfig.subBaseUrl}/iban_addbeneficary"));

      // Adding fields to the request
      request.fields.addAll({
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        'first_name': name!,
        "last_name": lastname!,
        "company_name": companyname!,
        'email': email!,
        'account': iban!,
        'is_business_personal': type!,
        "bic": bic!,
      });

      // Adding User-Agent header
      request.headers['User-Agent'] = AppConfig.userAgent;

      // Adding image file if provided
      if (image != null && image.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'beneficiary_upload_image', image));
      }

      // Sending the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(await response.stream.bytesToString());
        print("This is response from add beneficiary: $jsonResponse");
        return StatusModel.fromJson(jsonResponse);
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } on ApiException catch (e) {
      print("API Exception: $e");
      throw e;
    } catch (e) {
      print("General Exception: $e");
      throw e;
    }
  }

  Future ibanlist({required String beneficiaryId}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "beneficiary_id": beneficiaryId,
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

  Future dynamicBeneficiaryFieldList(
      {required String country,
      required String currency,
      required String accountType}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "country": country,
        "currency": currency,
        "accountType": accountType,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.dynamicBeneficiaryFieldList);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return DynamicBeneficiaryFieldModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future addDynamicBeneficiary({
    required String country,
    required String currency,
    required String accountType,
    required String recipientCountry,
    required String image,
    required String beneficiaryIdentificationType,
    required String beneficiaryIdentificationValue,
    required List dynamicData,
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
        "country": country,
        "currency": currency,
        "accountType": accountType,
        "beneficiary_country": recipientCountry,
        "bankdetail": dynamicData,
        "beneficiary_identification_type": beneficiaryIdentificationType,
        "beneficiary_identification_value": beneficiaryIdentificationValue,
        "image": image,
      };

      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.dynamicAddBeneficiary);

      print("response : $response");

      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return DynamicAddBeneficiaryModel.fromJson(jsonResponse);
    } on ApiException catch (e) {
      print(e);
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future swiftSendMoneyFun(
      {String? reference,
      String? amount,
      String? ibanid,
      String? beneficiary,
      String? paymentoption,
      String? sendNotification,
      String? seOnSession,
      String? paymentCode,
      int? swiftShared}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "reason_payment": reference,
        "amount": amount,
        "beneficiary_id": beneficiary,
        'payment_option': paymentoption,
        'iban_id': ibanid,
        'swift_shared': swiftShared.toString(),
        'send_notification': sendNotification,
        'payment_code': paymentCode,
        'seonsession': seOnSession,
      };

      debugPrint(" bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.getSwiftSendMoneyData);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SwiftPaymentModel.fromJson(jsonResponse);
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

  Future swiftSendMoneyPaymentCode({String? id}) async {
    try {
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "token": token,
        "beneficiary_id": id,
      };

      debugPrint("bodyData $bodyData");
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.getSwiftPaymentCode);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SwiftSendMoneyUserModel.fromJson(jsonResponse);
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
