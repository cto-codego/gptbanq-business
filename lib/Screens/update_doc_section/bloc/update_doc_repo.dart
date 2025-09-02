import 'dart:convert';
import 'dart:io';

import 'package:gptbanqbusiness/Models/kyc/kyc_address_verify_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_face_verify_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_get_user_image_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_id_verify_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_status_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_submit_model.dart';
import 'package:gptbanqbusiness/Models/kyc/user_kyc_check_status_model.dart';
import 'package:gptbanqbusiness/Models/update_doc/update_doc_check_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/networking/network_manager.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/get_imei.dart';
import 'package:gptbanqbusiness/utils/get_ip_address.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../Models/kyc/get_kyc_user_status_model.dart';
import '../../../Models/kyc/kyc_create_model.dart';
import '../../../Models/kyc/kyc_document_type_model.dart';

class UpdateDocRepo {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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

  Future kycIdVerify(
      {required String uniqueId, required String docTypeStatus}) async {
    String ipAddress = await GetIPAddress().getIps();
    String userID = await UserDataManager().getUserId();
    String type = await UserDataManager().getKycDocType();

    String frontImagePath = type == "passport"
        ? await UserDataManager().getPassportImage()
        : await UserDataManager().getIdCardFrontImageCheck();

    String backImagePath =
        type == "passport" ? '' : await UserDataManager().getIdCardBackImage();

    final requestUrl = "${AppConfig.baseUrl}${AppConfig.updateDocUploadApi}";
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
      'unique_id': uniqueId,
      'doc_type_status': docTypeStatus,
      'id_type': type,
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

  Future kycAddressVerify(
      {required String uniqueId, required String docTypeStatus}) async {
    String ipAddress = await GetIPAddress().getIps();
    String userID = await UserDataManager().getUserId();

    String filePath = await UserDataManager().getAddressImage();

    final requestUrl = "${AppConfig.baseUrl}${AppConfig.updateDocUploadApi}";
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
      'unique_id': uniqueId,
      'doc_type_status': docTypeStatus,
      'id_type': "Address Proof",
      'ipaddress': ipAddress,
    });

    // Log headers and fields
    debugPrint("=== API REQUEST HEADERS ===");
    request.headers.forEach((key, value) => debugPrint("$key: $value"));

    debugPrint("=== API REQUEST FIELDS ===");
    request.fields.forEach((key, value) => debugPrint("$key: $value"));

    // Determine MIME type
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

    // Check if PDF or Image
    if (mimeType == 'application/pdf') {
      // PDF upload
      var pdfFile = await http.MultipartFile.fromPath(
        'address_proof',
        filePath,
        contentType: MediaType('application', 'pdf'),
      );
      request.files.add(pdfFile);
      debugPrint("address_proof: ${pdfFile.filename}");
    } else {
      // Image upload
      final mimeSplit = mimeType.split('/');
      var imageFile = await http.MultipartFile.fromPath(
        'address_proof',
        filePath,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      );
      request.files.add(imageFile);
      debugPrint("address_proof: ${imageFile.filename}");
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        UserDataManager().clearAddressImage(); // Optional
        return KycAddressVerifyModel.fromJson(jsonResponse);
      } else {
        throw Exception("Upload failed: ${response.reasonPhrase}");
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
      throw e; // Rethrow ApiException for handling in higher-level code
    } catch (e) {
      debugPrint(e.toString());
      throw e; // Rethrow other exceptions for handling in higher-level code
    }
  }

  Future kycGetUserImage({required String uniqueId}) async {
    String userID;
    userID = await UserDataManager().getUserId();

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
        "unique_id": uniqueId,
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

  Future kycFaceVerify(
      {required String image,
      required String uniqueId,
      required String docTypeStatus}) async {
    String userID;
    userID = await UserDataManager().getUserId();

    String userImage;
    userImage = image;
    String similarity;
    similarity = await UserDataManager().getSimilarityData();
    String ipAddress = await GetIPAddress().getIps();

    print(userImage);

    try {
      Map<String, dynamic> bodyData = {
        "authkey": AppConfig.authKey,
        "secretkey": AppConfig.secretKey,
        "whitelablel": AppConfig.whiteLabel,
        "user_id": userID,
        'unique_id': uniqueId,
        'doc_type_status': docTypeStatus,
        'id_type': "Profile",
        // "similarity": similarity,
        'ipaddress': ipAddress,
        "userimage": "data:image/png;base64,$userImage",
      };
      debugPrint("bodyData : ");
      debugPrint(bodyData.toString());
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.updateDocUploadApi);

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

  //update doc section
  Future updateDocCheckStatus() async {
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
      debugPrint("bodyData : ${bodyData.toString()}");
      Response? response = await NetworkManager().callApi(
          method: HttpMethod.Post,
          body: bodyData,
          urlEndPoint: AppConfig.updateDocCheckStatus);

      debugPrint("response : $response");
      Map<String, dynamic> jsonResponse = jsonDecode(response!.data);

      return UpdateDocCheckModel.fromJson(jsonResponse);
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
