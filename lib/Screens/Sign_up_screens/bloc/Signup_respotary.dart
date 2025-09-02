import 'dart:convert';
import 'dart:io';

import 'package:gptbanqbusiness/Models/Plans_model.dart';
import 'package:gptbanqbusiness/Models/Set_pin_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_address_verify_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_face_verify_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_get_user_image_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_id_verify_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_status_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_submit_model.dart';
import 'package:gptbanqbusiness/Models/kyc/user_kyc_check_status_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:gptbanqbusiness/Models/curruncy_model.dart';
import 'package:gptbanqbusiness/Models/income_model.dart';
import 'package:gptbanqbusiness/Models/login_response.dart';
import 'package:gptbanqbusiness/Models/planLinkModel.dart';
import 'package:gptbanqbusiness/Models/signup_response_model.dart';
import 'package:gptbanqbusiness/Models/sourceoffund.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/user_get_pin_model.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/device_info.dart';
import 'package:gptbanqbusiness/utils/get_imei.dart';
import 'package:gptbanqbusiness/utils/get_ip_address.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_parser/http_parser.dart';

import '../../../Models/dashboard/refresh_sumsub_token_model.dart';
import '../../../Models/kyc/get_kyc_user_status_model.dart';
import '../../../Models/kyc/kyc_create_model.dart';
import '../../../Models/kyc/kyc_document_type_model.dart';
import '../../../Models/login_section/forgot_password_model.dart';
import '../../../Models/login_section/forgot_password_otp_model.dart';
import '../../../Models/login_section/login_email_verified_model.dart';
import '../../../Models/signup_models/signup_email_verified_model.dart';
import '../../../Models/signup_models/user_signup_account_model.dart';

class SignupRespo {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future loginRequestVerify(
      {required String token,
      required String verificationCode,
      required String userId}) async {
    try {
      String? imei = await DeviceIMEI().creatrandom();
      String? sessionData = await UserDataManager().getUserDeviceInfo();


      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "token": token,
        "logincode": verificationCode,
        "user_id": userId,
        "imei": imei,
        "sessiondata": sessionData,
      };

      debugPrint("loginRequest bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.userLoginVerify);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return LoginEmailVerifiedModel.fromJson(jsonResponse);
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

  Future<StatusModel> Sendemaiotp({required String email}) async {
    String? imei = await DeviceIMEI().creatrandom();
    String ipAddress = '';
    ipAddress = await GetIPAddress().getIps();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'email': email,
        'imei': imei,
        'ipaddress': ipAddress,
      };
      print("bodyData : ");
      print(bodyData);
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointOTPemail);

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

  Future refreshSumSubTokenRequest() async {
    try {
      String? imei = await DeviceIMEI().creatrandom();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "imei": imei,
      };

      debugPrint(
          "✍️✍️✍️🐞️user refresh sum sub token request bodyData 🐞️✍️✍️✍️");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.refreshSumSubToken);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return RefreshSumSubTokenModel.fromJson(jsonResponse);
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

  Future loginRequest({
    required String email,
    required String password,
    required String deviceType,
    required String seOnSession,
  }) async {
    try {
      String? imei = await DeviceIMEI().creatrandom();
      String? deviceToken = await getDeviceToken();
      String ipAddress = '';
      ipAddress = await GetIPAddress().getIps();
      debugPrint('ipAddress: $ipAddress');
      String? sessionData = await UserDataManager().getUserDeviceInfo();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "imei": imei,
        "email": email,
        "password": password,
        "seonsession": seOnSession,
        "ipaddress": ipAddress,
        "device_type": Platform.isAndroid ? "Android" : "ios",
        "device_token": deviceToken,
        "sessiondata": sessionData,
      };

      debugPrint("loginRequest bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.userLoginAccount);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return LoginResponse.fromJson(jsonResponse);
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

  Future<UserGetPinModel> getNewPin(String userPin, version, seonData) async {
    try {
      String? imei = await DeviceIMEI().creatrandom();
      String userId = await UserDataManager().getUserId();
      String token = await UserDataManager().getToken();
      String? sessionData = await UserDataManager().getUserDeviceInfo();


      String ipAddress = '';
      ipAddress = await GetIPAddress().getIps();
      debugPrint('ipAddress: $ipAddress');

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "pin": userPin,
        "imei": imei,
        "token": token,
        "version": version,
        "device_token": User.deviceToken,
        "ipaddress": ipAddress,
        "seonsession": seonData,
        "sessiondata": sessionData,
      };

      debugPrint("getNewPin bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointUserGetPin);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      debugPrint(
          "------------------------------------testing ap-------------------");
      debugPrint(response.data.toString());
      debugPrint(
          "------------------------------------testing ap-------------------");
      return UserGetPinModel.fromJson(jsonResponse);
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

  Future incomesourcefun() async {
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
          urlEndPoint: AppConfig.endPointincomesource);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return IncomeModel.fromJson(jsonResponse);
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

  Future getsourcefund() async {
    String userID;
    userID = await UserDataManager().getUserId();
    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'user_id': userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointsourcefund);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SourceFund.fromJson(jsonResponse);
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

  // iban_updateSource
  Future uploadsourceoffund(
      {String? occupation, source, image, signature}) async {
    String userID;
    userID = await UserDataManager().getUserId();

    String token = await UserDataManager().getToken();

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('${AppConfig.baseUrl}${AppConfig.updateSof}'));

      // Add headers, including User-Agent
      request.headers.addAll({
        'User-Agent': AppConfig.userAgent,
      });

      // Add fields
      request.fields.addAll({
        'authkey': AppConfig.authKey,
        'secretkey': AppConfig.secretKey,
        'whitelablel': AppConfig.whiteLabel,
        'token': token,
        'user_id': userID,
        'occupations': occupation!,
        'source_of_fund': source,
        'signature': "data:image/png;base64,$signature",
      });

      debugPrint(request.toString());
      debugPrint(request.fields.toString());

      // Add file
      request.files
          .add(await http.MultipartFile.fromPath('proof_of_fund', image));
      debugPrint(request.files.toString());

      // Send request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(await response.stream.bytesToString());

        debugPrint("response : $jsonResponse");

        return StatusModel.fromJson(jsonResponse);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
      throw (e);
    } catch (e) {
      debugPrint(e.toString());
      throw (e);
    }
  }

  Future otpVerification(
      {required String otp,
      required String email,
      required String deviceType}) async {
    String? imei = await DeviceIMEI().creatrandom();
    String? deviceToken = await getDeviceToken();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'activation_code': otp,
        'imei': imei,
        'email': email,
        'device_type': deviceType,
        'device_token': deviceToken,
      };
      debugPrint("email verification data : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.userSignupEmailVerification);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return SignupEmailVerifiedModel.fromJson(jsonResponse);
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

  Future<StatusModel> ResendtpVerification() async {
    String? imei = await DeviceIMEI().creatrandom();
    String ipAddress = '';
    ipAddress = await GetIPAddress().getIps();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'imei': imei,
        'email': User.email,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointResendOTPverification);

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

  Future Setpin({required String pincode}) async {
    String? imei = await DeviceIMEI().creatrandom();

    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'imei': imei,
        'user_id': userID,
        'pin': pincode
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointSetUserPin);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SetUserPinResponseModel.fromJson(jsonResponse);
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

  Future Sendkyc() async {
    String? imei = await DeviceIMEI().creatrandom();

    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'imei': imei,
        'user_id': userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointSendkyclink);

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

  Future upgradeplan({String? unquid}) async {
    String? imei = await DeviceIMEI().creatrandom();

    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'imei': imei,
        'user_id': userID,
        "unique_id": unquid
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointUpgradeplan);

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

  Future Getplanlist() async {
    String? imei = await DeviceIMEI().creatrandom();

    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'imei': imei,
        'user_id': userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.endPointgetplans);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return PlansModel.fromJson(jsonResponse);
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

  Future getplanlink() async {
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
          urlEndPoint: AppConfig.endPointplanlink);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return Planlinkmodel.fromJson(jsonResponse);
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

  Future<StatusModel> uploadProfilePicture(
      {required String fileProfilePicturePath}) async {
    try {
      String userID;
      userID = await UserDataManager().getUserId();

      debugPrint("userID : $userID");
      String profilePictureName = fileProfilePicturePath.split('/').last;
      String fileExtension = profilePictureName.split('.').last;
      debugPrint("formData 1 : ");

      MultipartFile multiPartProfilePicture = await MultipartFile.fromFile(
        fileProfilePicturePath,
        filename: profilePictureName,
        contentType: MediaType('image', fileExtension),
      );

      FormData formData = FormData.fromMap({
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
        "profile_image": multiPartProfilePicture,
      });

      debugPrint("formData : $formData");
      Response? response = await NetworkManager().callApi(
        method: HttpMethod.Post,
        formData: formData,
        urlEndPoint: AppConfig.endPointUploadProfile,
        isMedia: true,
      );

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

  Future<StatusModel> uploadKycproffAdreess(
      {required String passportpic}) async {
    try {
      String userID;
      userID = await UserDataManager().getUserId();

      debugPrint("userID : $userID");
      String fileNameFront = passportpic.split('/').last;
      debugPrint("fileNameFront path : $passportpic");
      debugPrint("fileFront name : $fileNameFront");
      String fileExtensionFront = fileNameFront.split('.').last;

      MultipartFile multiPartFrontPhoto = await MultipartFile.fromFile(
        passportpic,
        filename: fileNameFront,
        contentType: MediaType('image', fileExtensionFront),
      );

      FormData formData = FormData.fromMap({
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
        "document_id": '2',
        "address_proof": multiPartFrontPhoto,
      });

      debugPrint("formData : $formData");
      Response? response = await NetworkManager().callApi(
        method: HttpMethod.Post,
        formData: formData,
        urlEndPoint: AppConfig.endPointUploadAddressProof,
        isMedia: true,
      );

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

  /*signup section*/
  Future userSignupAccountRequest({
    required String name,
    required String surname,
    required String email,
    required String password,
    required String deviceType,
    required String seonSession,
  }) async {
    try {
      String? imei = await DeviceIMEI().creatrandom();
      String ipAddress = '';
      ipAddress = await GetIPAddress().getIps();
      debugPrint('ipAddress: $ipAddress');

      UserDataManager().setUserEmailSave(email);
      User.email = email;

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "name": name,
        "surname": surname,
        "email": email,
        "password": password,
        "seonsession": seonSession,
        "imei": imei,
        "ipaddress": ipAddress,
      };

      debugPrint("✍️✍️✍️🐞️user signup account request bodyData 🐞️✍️✍️✍️");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.userSignupAccount);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      if (jsonResponse["status"] == 0) {
        return StatusModel.fromJson(jsonResponse);
      } else {
        return UserSignupAccountModel.fromJson(jsonResponse);
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

  Future<SignUpResponseModel> signupdata() async {
    await firebaseCloudMessaging_Listeners();

    Map<String, dynamic> deviceInfo = await DeviceInfo().getDeviceInfo();

    String deviceCompleteModel = '';

    if (Platform.isIOS) {
      deviceCompleteModel = deviceInfo['name'];
    } else {
      deviceCompleteModel =
          deviceInfo['manufacturer'] + ' ' + deviceInfo['model'];
    }
    debugPrint('deviceCompleteModel: $deviceCompleteModel');

    String? imei = await DeviceIMEI().creatrandom();
    String ipAddress = '';
    ipAddress = await GetIPAddress().getIps();

    String userEmail = "";
    userEmail = await UserDataManager().getUserEmail();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        'imei': imei,
        "email": userEmail,
        "phonecode": int.parse(User.Phonecode),
        "mobile": User.Phonenumber,
        "nationality": int.parse(User.Nationality!),
        "dob": User.dob,
        "gender": User.Gender,
        "address": User.address,
        "city": User.city,
        "country": int.parse(User.Country!),
        "zipcode": User.postcode,
        "device_type": Platform.isAndroid ? "Android" : "ios",
        "device_token": User.deviceToken,
        "ipaddress": ipAddress,
        "device_model": deviceCompleteModel,
        "country_pay_tax": User.TaxCountry,
        "tax_personal_number": User.taxincome,
        "income_source": User.icomesource,
        "purpose_account": User.purpose,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.userSignupOnboardProfile);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return SignUpResponseModel.fromJson(jsonResponse);
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

  Future getcurruncies() async {
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
          urlEndPoint: AppConfig.endPointGetcurruncies);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return CurrunciesModel.fromJson(jsonResponse);
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

  //kyc section

  Future getKycUserStatus() async {
    String? imei = await DeviceIMEI().creatrandom();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "imei": imei,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.kycGetUserAppStatus);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
      return GetKycUserStatusModel.fromJson(jsonResponse);
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

  Future getKycDocumentType() async {
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
          urlEndPoint: AppConfig.kycDocumentType);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      UserDataManager().kycDocTypeSave(jsonResponse["doc"][0]["type"] ?? "");

      print(jsonResponse["doc"][0]["type"]);
      return KycDocumentTypeModel.fromJson(jsonResponse);
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

  // Future kycIdVerify() async {
  //   String? imei = await DeviceIMEI().creatrandom();
  //   String ipAddress = '';
  //   ipAddress = await GetIPAddress().getIps();
  //
  //   String userID;
  //   userID = await UserDataManager().getUserId();
  //
  //   String type;
  //   type = await UserDataManager().getKycDocType();
  //
  //   String isFront;
  //   type == "passport"
  //       ? isFront = await UserDataManager().getPassportImage()
  //       : isFront = await UserDataManager().getIdCardFrontImageCheck();
  //
  //   print(isFront);
  //
  //   String isBack;
  //   isBack = await UserDataManager().getIdCardBackImage();
  //
  //   print(isBack);
  //
  //   try {
  //     Map<String, dynamic> bodyData = {
  //       "authkey": AppConfig.authKey,
  //       "secretkey": AppConfig.secretKey,
  //       "whitelablel": AppConfig.whiteLabel,
  //       "user_id": userID,
  //       "type": type,
  //       "ipaddress": ipAddress,
  //       "idfront": "data:image/png;base64,$isFront",
  //       "idback": type == "passport" ? " " : "data:image/png;base64,$isBack",
  //     };
  //     debugPrint("bodyData : ");
  //     debugPrint(bodyData.toString());
  //     Response? response = await NetworkManager().callApi(
  //         method: HttpMethod.Post,
  //         body: bodyData,
  //         urlEndPoint: AppConfig.kycIdVerify);
  //
  //     debugPrint("response : $response");
  //     Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
  //
  //     UserDataManager().clearIdCardFrontImage();
  //     UserDataManager().clearIdCardBackImage();
  //     UserDataManager().clearPassportImage();
  //     return KycIdVerifyModel.fromJson(jsonResponse);
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

  Future kycIdVerify() async {
    String ipAddress = await GetIPAddress().getIps();
    String userID = await UserDataManager().getUserId();
    String type = await UserDataManager().getKycDocType();

    String frontImagePath = type == "passport"
        ? await UserDataManager().getPassportImage()
        : await UserDataManager().getIdCardFrontImageCheck();

    String backImagePath =
        type == "passport" ? '' : await UserDataManager().getIdCardBackImage();

    final requestUrl = "${AppConfig.baseUrl}${AppConfig.kycUploadIdDoc}";
    debugPrint("Request URL: $requestUrl");

    // Initialize MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(requestUrl),
    );

    // Add headers, including User-Agent
    request.headers.addAll({
      'User-Agent': AppConfig.userAgent,
    });

    // Add fields to the request
    request.fields.addAll({
      'authkey': AppConfig.authKey,
      'secretkey': AppConfig.secretKey,
      'whitelablel': AppConfig.whiteLabel,
      'user_id': userID,
      'type': type,
      'ipaddress': ipAddress,
    });

    // Print request fields
    debugPrint("Request Fields:");
    request.fields.forEach((key, value) {
      debugPrint("$key: $value");
    });

    // Add front image file if needed
    if (frontImagePath.isNotEmpty) {
      var frontImageFile = await http.MultipartFile.fromPath(
        'front_side',
        frontImagePath,
        contentType: MediaType('image', 'png'), // Adjust if necessary
      );
      request.files.add(frontImageFile);
      debugPrint(
          "Added front image file: ${frontImageFile.filename}, size: ${frontImageFile.length} bytes");
    }

    // Add back image file if needed
    if (backImagePath.isNotEmpty) {
      var backImageFile = await http.MultipartFile.fromPath(
        'back_side',
        backImagePath,
        contentType: MediaType('image', 'png'), // Adjust if necessary
      );
      request.files.add(backImageFile);
      debugPrint(
          "Added back image file: ${backImageFile.filename}, size: ${backImageFile.length} bytes");
    }

    // Print request details
    debugPrint("Request Files:");
    for (var file in request.files) {
      debugPrint(
          "File Field: ${file.field}, File Name: ${file.filename}, Size: ${file.length} bytes");
    }

    try {
      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint("Response: $responseBody");

        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        UserDataManager().clearIdCardFrontImage();
        UserDataManager().clearIdCardBackImage();
        UserDataManager().clearPassportImage();
        return KycIdVerifyModel.fromJson(jsonResponse);
      } else {
        debugPrint("Error: ${response.reasonPhrase}");
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
      throw e; // Rethrow ApiException for handling in higher-level code
    } catch (e) {
      debugPrint(e.toString());
      throw e; // Rethrow other exceptions for handling in higher-level code
    }
  }

  // Future kycAddressVerify(String addressImage) async {
  //   String ipAddress = '';
  //   ipAddress = await GetIPAddress().getIps();
  //
  //   String userID;
  //   userID = await UserDataManager().getUserId();
  //
  //   // String addressImage;
  //   // addressImage = await UserDataManager().getAddressImage();
  //
  //   // print("addressImage : $addressImage");
  //
  //   try {
  //     Map<String, dynamic> bodyData = {
  //       "authkey": AppConfig.authKey,
  //       "secretkey": AppConfig.secretKey,
  //       "whitelablel": AppConfig.whiteLabel,
  //       "user_id": userID,
  //       "ipaddress": ipAddress,
  //       "addressdoc": "data:image/png;base64,$addressImage",
  //     };
  //     debugPrint("bodyData : ");
  //     debugPrint(bodyData.toString());
  //     Response? response = await NetworkManager().callApi(
  //         method: HttpMethod.Post,
  //         body: bodyData,
  //         urlEndPoint: AppConfig.kycAddressVerify);
  //
  //     debugPrint("response : $response");
  //     Map<String, dynamic> jsonResponse = jsonDecode(response!.data);
  //
  //     UserDataManager().clearAddressImage();
  //     return KycAddressVerifyModel.fromJson(jsonResponse);
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

  Future kycAddressVerify() async {
    String ipAddress = await GetIPAddress().getIps();
    String userID = await UserDataManager().getUserId();

    String imagePth = await UserDataManager().getAddressImage();

    final requestUrl = "${AppConfig.baseUrl}${AppConfig.kycUploadAddressDoc}";
    debugPrint("Request URL: $requestUrl");

    // Initialize MultipartRequest
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(requestUrl),
    );

    // Add headers, including User-Agent
    request.headers.addAll({
      'User-Agent': AppConfig.userAgent,
    });

    // Add fields to the request
    request.fields.addAll({
      'authkey': AppConfig.authKey,
      'secretkey': AppConfig.secretKey,
      'whitelablel': AppConfig.whiteLabel,
      'user_id': userID,
      'ipaddress': ipAddress,
    });

    // Print request fields
    debugPrint("Request Fields:");
    request.fields.forEach((key, value) {
      debugPrint("$key: $value");
    });

    // Add front image file if needed
    if (imagePth.isNotEmpty) {
      var addressImageFile = await http.MultipartFile.fromPath(
        'address_proof',
        imagePth,
        contentType: MediaType('image', 'png'), // Adjust if necessary
      );
      request.files.add(addressImageFile);
      debugPrint(
          "Added address proof file: ${addressImageFile.filename}, size: ${addressImageFile.length} bytes");
    }

    // Print request details
    debugPrint("Request Files:");
    for (var file in request.files) {
      debugPrint(
          "File Field: ${file.field}, File Name: ${file.filename}, Size: ${file.length} bytes");
    }

    try {
      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        debugPrint("Response: $responseBody");

        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        UserDataManager().clearAddressImage();
        return KycAddressVerifyModel.fromJson(jsonResponse);
      } else {
        debugPrint("Error: ${response.reasonPhrase}");
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
      throw e; // Rethrow ApiException for handling in higher-level code
    } catch (e) {
      debugPrint(e.toString());
      throw e; // Rethrow other exceptions for handling in higher-level code
    }
  }

  Future kycGetUserImage() async {
    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.kycFaceVerifyImage);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      print("${jsonResponse["profileimage"]}");
      return KycGetUserImageModel.fromJson(jsonResponse);
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

  Future loginBioStatus(
      {required String status, required String userId}) async {
    try {
      String? imei = await DeviceIMEI().creatrandom();

      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "imei": imei,
        "user_id": userId,
        "status": status,
      };

      debugPrint("loginRequest bodyData");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.userLoginBiometric);

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

  Future kycFaceVerify({required String image}) async {
    String userID;
    userID = await UserDataManager().getUserId();

    String userImage;
    userImage = image;
    String similarity;
    similarity = await UserDataManager().getSimilarityData();

    print(userImage);

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
        "similarity": similarity,
        "userimage": "data:image/png;base64,$userImage",
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.kycFaceVerifyDoc);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      UserDataManager().clearSimilarityImage();
      UserDataManager().clearSimilarity();
      UserDataManager().clearSimilarityUserImage();

      return KycFaceVerifyModel.fromJson(jsonResponse);
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

  Future kycSubmit() async {
    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.kycSubmitData);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return KycSubmitModel.fromJson(jsonResponse);
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

  Future kycSubmitIsWallet() async {
    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.kycSubmitDataIsWallet);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return KycSubmitModel.fromJson(jsonResponse);
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

  Future userKycStatusCheck() async {
    String? imei = await DeviceIMEI().creatrandom();
    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "imei": imei,
        "user_id": userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.userKycCheckStatus);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return UserKycCheckStatusModel.fromJson(jsonResponse);
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

  Future kycStatusCheck() async {
    String? imei = await DeviceIMEI().creatrandom();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "imei": imei,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.kycGetUserAppStatus);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return KycStatusModel.fromJson(jsonResponse);
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

  Future kycCreate() async {
    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.kycCreateStatus);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return KycCreateModel.fromJson(jsonResponse);
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

  Future forgotPassword({required String email}) async {
    String ipAddress = '';
    ipAddress = await GetIPAddress().getIps();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "email": email,
        "ip_address": ipAddress,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.forgotPasswordApi);

      debugPrint("forgot password response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return ForgotPasswordModel.fromJson(jsonResponse);
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

  Future forgotPasswordOtp(
      {required String uniqueId,
      required String userId,
      required String code,
      required String seonData}) async {
    String ipAddress = '';
    ipAddress = await GetIPAddress().getIps();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "unique_id": uniqueId,
        "user_id": userId,
        "code": code,
        "ip_address": ipAddress,
        "seonsession": seonData,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.forgotPasswordVerifyOtpApi);

      debugPrint("forgot password otp response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return ForgotPasswordOtpModel.fromJson(jsonResponse);
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

  Future forgotPasswordBiometric(
      {required String status, required String userId}) async {
    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "status": status,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.forgotPasswordBiometricStatusApi);

      debugPrint("forgot password biometric response : $response");
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

  Future resetPassword(
      {required String userId,
      required String password,
      required String confirmPassword}) async {
    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userId,
        "password": password,
        "confirm_password": confirmPassword,
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.updatePasswordApi);

      debugPrint("forgot password update password response : $response");
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

  ////////////
  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      // final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<void> firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();

    User.deviceToken = await _firebaseMessaging.getToken();
  }

  void iOS_Permission() {
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<String?> getDeviceToken() async {
    if (Platform.isIOS) iOS_Permission();

    String? deviceToken = await _firebaseMessaging.getToken();

    return deviceToken;
  }
}
