// ignore_for_file: dead_code

import 'dart:convert';

import 'package:gptbanqbusiness/Models/application.dart';
import 'package:gptbanqbusiness/Screens/no_network_connection/no_network_connection.dart';
import 'package:gptbanqbusiness/Screens/no_network_connection/server_error_screen.dart';
import 'package:gptbanqbusiness/utils/connectionStatusSingleton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/strings.dart';

class AppConfig {
  static String baseUrl = "https://api7645348654.codegotech.com/biban/";

  static String subBaseUrl = "https://api7645348654.codegotech.com/biban";

  // For cardapi

  static String baseUrl2 = "https://api7645348654.codegotech.com/new_cardapi/";

  static const String version = "/api/v1/";
  static const String authKey =
      "thebank20201234567891011121crypto07a932dd17adc59b49561f";
  static const String secretKey =
      "thebank20201234567891011121crypto07a932dd17adc59b49561f";
  static const String whiteLabel =
      "6a392898-19a62a49-b69ee746-cfbf5d3d-87ddeec6-ae073358-0161a9e1-0b473afc";
  static String userAgent =
      "ptbanq-b69ee746-cfbf5d3d-87ddeec6-ae073358-0161a9e1-0b473afc";

  static const String endPointtrxdetails = 'iban_trxdetail';
  static const String endPointdawnloainvoice = 'iban_downloadinvoice';
  static const String endPointIbanregula = 'iban_regulaupdateBiometric';

  static const String endPointCountriesApi = 'iban_countries_get';
  static const String endPointIncomeSource = 'income_source';
  static const String endPointMobileVerify = 'mobileverify';
  static const String endPointOTPemail = 'iban_singup_email';
  static const String endPointincomesource = 'income_source';

  static const String endPointordercard = 'debitcard_fees';
  static const String endPointplanlink = 'iban_getPlanLink';

  static const String endPointOTPverification = 'signup_verify_email';
  static const String endPointResendOTPverification = 'signup_resendcode';
  static const String endPointGetcurruncies = 'signup_user_wallet_currency';
  static const String endPointSignupdata = 'iban_signup_personal';
  static const String endPointIbancheckcard = 'iban_debitCardList';

  static const String endPointUploadProfile = 'signup_uploadprofile';
  static const String endPointUploaddocument = 'iban_upload_trx_document';

  static const String endPointGetallwallet = 'iban_dashboard';
  static const String endPointDashboard = 'dashboard_wallet';
  static const String endPointmaindash = 'dashboard';

  static const String endPointSharemail = 'iban_shareiban';
  static const String endPointclosenotifcation = 'iban_close';
  static const String endPointApproveeurotoiban =
      'wcoin_approve_cryptoeur_to_iban';

  static const String endPointApproveeurotocrypto =
      'iban_confirm_transaction_crypto';

  static const String updateSof = 'sdkkyc_updateSource';

  static const String getIbanMultipleCurrency = 'cycloud_getavailablecurrency';
  static const String getIbanMultipleList = 'cycloud_getavailableIban';
  static const String createIban = 'cycloud_createiban';

  //iban list
  static const String endPointDashboardIbanlist = 'iban_getAlliban';
  static const String endPointIbanlist = 'cycloud_getAlliban';
  static const String endPointcreatiban = 'iban_createiban';
  static const String getIbanCurrency = 'iban_getIbanCurrency';

  static const String ibanCheckSumSubVerified = 'sdkkyc_checkSumsubverfied';

  static const String endPointApproveIbanSwiftTransaction =
      'cycloud_confirmmulitswiftpayment';
  static const String getSwiftPaymentCode = 'cycloud_getpaymentcode';

  /*master node section*/
  static const String nodeModule = 'mnode_module';
  static const String nodeLogs = 'mnode_logs';
  static const String nodeProfitLogs = 'mnode_profitLogs';
  static const String nodeGetOrderInfo = 'mnode_getorderInfo';
  static const String nodeOrder = 'mnode_order';

  static const String endPointSendTransaction = 'crypto_withdraw';

  static const String endPointNetwork = 'wcoin_getnetwork';

  static const String endPointconfirmexchange = 'crypto_submit_exchange';
  static const String endPointmovebalance = 'move_maincrypto_to_debitcrypto';

  static const String endPointGetWalletList = 'wallet_currency_list';

  static const String endPointCreatewallet = 'create_wallet';
  static const String endPointwalletconertion = 'conversion_wallet_list';
  static const String endPointConversion = 'conversion_wallet';
  static const String endPointwirecurruncy = 'wire_country_currency';
  static const String endPointCryptooins = 'wcoin_crypto_wallet';
  static const String endPointCoindetails = 'wcoin_crypto_wallet_detail';
  static const String endPointMoveeurotoiban = 'wcoin_move_ceur_to_iban';

  static const String endPointsourcefund = 'iban_sorucefund';

  static const String endPointSenmessage = 'sendMessage';
  static const String endPointReadmessages = 'readMessage';

  static const String endPointSendinternalcoin = 'crypto_withdraw_beneficary';

  static const String endPointGenerateqr = 'wcoin_generate_qrcode';
  static const String endPointlistofsavedaddress = 'wcoin_listaddress';

  static const String endPointsavesenderadd = 'wcoin_save_sender_address';

  static const String endPointqetqrcode = 'wcoin_crypto_qrcode';
  static const String endPointcryptomain = 'wcoin_move_crypto_to_main';

  static const String endPointmaincrypto = 'wcoin_move_main_to_crypto';

  static const String endPointcryptotradelist = 'crypto_trade_list';

  static const String endPointcryptoPreview = 'crypto_exchange_preview';
  static const String endPointeurotocrypto = 'iban_depositeurcrypto';

  static const String endPointautotrading = 'ongoing_autotrading_profit';
  static const String endPointcompletetrading = 'completed_autotrading_profit';

  static const String endPointResendOTP = 'resendotp';
  static const String endPointSignup = 'signup';
  static const String endPointActivateAccount = 'activate_account';
  static const String endPointResendCode = 'resendcode';
  static const String endPointUploadKycIos = 'upload_kyc_ios';
  static const String endPointSendchatimg = 'sendImgMessage';

  static const String endPointUploadVideo = 'upload_video';
  static const String endPointGetUserStatus = 'get_user_app_status';
  static const String endPointNationality = 'nationality';
  static const String endPointCheckExistingEmail = 'check_existing_email';
  static const String endPointSetUserPin = 'iban_user_setpin';
  static const String endPointSendkyclink = 'iban_sendkyclink';
  static const String endPointgetplans = 'iban_getPlan';
  static const String endPointUpgradeplan = 'iban_upgradePlan';

  static const String endPointUserGetPin = 'iban_user_getpin';
  static const String endPointCreateIban = 'create_iban';
  static const String endPointIbanFees = 'iban_fees';
  static const String endPointPprocessIban = 'process_iban';
  static const String endPointCardFees = 'card_fees';
  static const String endPointCardOrder = 'card_order';
  static const String endPointCardDetails = 'card_details';
  static const String endPointUpdateCardSettings = 'update_card_settings';
  static const String endPointBeneficiaryList = 'iban_beneficiary_list';
  static const String endPointIbanpush = 'iban_sendPush';

  static const String endPointSepa = 'iban_sepatype';

  static const String endPointResetCardPin = 'reset_card_pin';
  static const String endPointTransactionList = 'transaction_list';
  static const String endPointBeneficiaryCountries = 'beneficiary_countries';
  static const String endPointAddBeneficiary = 'add_beneficiary';
  static const String endPointUserProfile = 'user_profile';
  static const String endPointdeleteUserProfile = 'delete_user_account';

  static const String endPointSendMoney = 'iban_sendmoney';
  static const String endPointAppSignIn = 'iban_appsignin';
  static const String endPointVerifyAccountSignIn = 'iban_verifylogin';
  static const String endPointApproveBrowserLogin = 'iban_verify_browser_login';
  static const String endPointApproveTransaction = 'approve_transaction';
  static const String endPointApproveibanTransaction = 'iban_confirmpush';
  static const String endPointprofile = 'iban_profile';
  static const String endPointlogout = 'iban_logout';

  static const String endPointApproveHscardTransaction =
      'hs_confirm_generate_virtual_card';

  static const String endPointNotificationsList = 'notifications_list';
  static const String endPointCoinlist = 'coinlist';
  static const String endPointselectcoin = 'select_coin_by_user';
  static const String endPointportfolio = 'portfolio';
  static const String endPointsortportfolio = 'sort_portfolio';
  static const String endPointMovebalancetodebit = 'move_wallet_to_debit';
  static const String endPointdebittowallet = 'move_debitcrypto_to_maincrypto';
  static const String endPointamounlist = 'stripe_amount_list';
  static const String endPointAppleamounlist = 'stripe_amount_apple_list';

  static const String endPointstipefees = 'stripe_fee';
  static const String endPointstipeapplefees = 'stripe_apple_fee';

  static const String endPointstipedeposite = 'stripe_deposit';
  static const String endPointresnedliivness = 'virtualcard_hs_resend_liveness';
  static const String endPointChangecardstatus = 'cardChangeStatus';

  static const String endPointstipeKeys = 'stripe_key';
  static const String endPointcheckusre = 'check_user_for_load';
  static const String endPointMultiloadcard = 'multi_load_balance_card';
  static const String endPointconfirmotp = 'confirm_loadcard_otp';
  static const String endPointaddcardkyc = 'upload_topup_kyc_document';
  static const String endPointcardkyc = 'topup_kyc_status';

  static const String endPointverifiedcard = 'getverifiedcard';
  static const String endPointDeleteverifiedcard = 'delete_topup_kyc';

  static const String endPointFetchLinks = 'config';
  static const String endPointNotificationsUpdate = 'notifications_update';
  static const String endPointSuccessTransaction = 'success_transaction';
  static const String endPointIBANAccounts = 'iban_accounts';
  static const String endPointMoveBalance = 'movebalance';
  static const String endPointInternalApproveTransaction =
      'internal_approve_transaction';
  static const String endPointTempActivateAccount = 'temp_activate_account';
  static const String endPointCardImage = 'card_image';
  static const String endPointDeleteBeneficiary = 'iban_delete_beneficiary';
  static const String endPointWireTransfer = 'deposit';
  static const String endPointVoucher = 'voucher';
  static const String endPointVirtualfees = 'virtual_gc_fee';
  static const String endPointVirtualcardfees = 'virtualcard_fee';
  static const String endPointVirtualcardhsfees = 'virtualcard_hs_fee';

  static const String endPointVirtualgenerate = 'generate_virtual_card';
  static const String endPointhsVirtualgenerate = 'hs_generate_virtual_card';

  static const String endPointVirtualcardlogs = 'virtual_cardlogs';
  static const String endPointVirtualhscardlogs = 'hs_virtual_cardlogs';

  static const String endPointVirtualcardactivate = 'virtualcard_card_activate';

  static const String endPointVirtualcardhsactivate =
      'virtualcard_hs_card_activate';

  static const String endPointPayQrCode = 'payqrcode';
  static const String endPointPrepaidCardFees = 'card_fees';
  static const String endPointdebitcard_fees = 'debitcard_fees';
  static const String endPointdebitcardplans = 'getMetalcard';
  static const String endPointdebitcardplanspreview = 'preview_plan';
  static const String endPointPosStatus = 'pos_order_status';
  static const String endPointPosdevices = 'pos_list';
  static const String endPointPosprview = 'pos_preview';
  static const String endPointPosConfirm = 'pos_order';
  static const String endPointPosSeial = 'pos_order_verify';
  static const String endPointsenddocs = 'pos_update_merchant_profile';
  static const String endPointPoscurruncylist = 'pos_user_currency';
  static const String endPointmakepayment = 'pos_make_payment';
  static const String endPointposplans = 'pos_plan';
  static const String endPointposselectplan = 'pos_choose_plan';
  static const String endPointPoscancel = 'pos_cancel_request_payment';
  static const String endPointposrecipt = 'pos_send_notification';
  static const String endPointpostrans = 'pos_transaction_log';
  static const String endPointposRefund = 'pos_refund_trx';
  static const String endPointposaproveimage = 'pos_make_payment_proof';

  static const String endPointconfirmmovewallet =
      'confirm_move_wallet_to_wallet';

  static const String endPointCreditcarddetails = 'debitcard_details';

  static const String endPointCheckpos = 'iban_checkPos';
  static const String endPointRequestpos = 'iban_sendPosrequest';

  static const String endPointTerminaldevices = 'iban_posTerminalList';
  static const String endPointTerminaltrx = 'iban_getPosTrxlist';
  static const String endPointTerminallog = 'iban_getPosPaymentlog';
  static const String endPointposplan = 'iban_posPlan';

  static const String endPointgetcarddetails = 'get_card_details';

  static const String endPointdebittrx = 'debitcard_trx_logs';
  static const String endPointprepaidcardtrans = 'ctrx';

  static const String endPointdebitcard_order = 'debitcard_order';

  static const String endPointPrepaidCardActivate = 'card_activate';
  static const String endPointPrepaidCardActivatenew = 'prepaid_card_activate';
  static const String endPointdebitCardActivatenew = 'debitcard_activate_code';

  static const String endPointdebitcard_activate = 'debitcard_activate';

  static const String endPointPrepaidCardDetails = 'card_details';
  static const String endPointLoadPrepaidCardBalance = 'load_balance_card';
  static const String endPointLoadPrepaidCardBalanceConfirm =
      'load_balance_card_confirm';
  static const String endPoint_QR_PAY_RECEIVER_INFO = 'getuserqrcode';
  static const String endPointAddInterBeneficiary = 'add_internal_beneficiary';
  static const String endPointShareQrCode = 'shareqrcode';
  static const String endPointUploadAddressProof = 'address_proof';

  static const String endPointgetbtcwallet = 'getbtcwallet';
  static const String endPointdebitmodule = 'debitcard_module_active';

  static const String endPointLoadmultiPrepaidCardBalanceConfirm =
      'confirm_loadcard_with_push';

  static const String endPointvirtualcardConfirm =
      'confirm_generate_virtual_card';

  static const String endPointcheckappversion = 'iban_checkappv';

  //payment information
  static const String trxPaymentDetails = 'trcard_get3dsdata';
  static const String trxPaymentConfirmOrCancel = 'trcard_approveDeclined';
  static const String cardBeneficiaryList = 'trcard_getCardbeneficiary';

  //git card api
  static const String giftCardList = 'gcard_list';
  static const String giftCardGetFeeType = 'gcard_getType';
  static const String giftCardGetFeeData = 'gcard_getFee';
  static const String giftCardOrderConfirm = 'gcard_orderCard';
  static const String giftCardDetails = 'gcard_details';
  static const String giftCardDelete = 'gcard_delete';
  static const String giftCardShare = 'gcard_share';

  //for virtual card section
  static const String addCardBeneficiary = 'trcard_addCardbeneficiary';
  static const String deleteCardBeneficiary = 'trcard_deleteCardbeneficiary';
  static const String cardToCardTransferFee = 'trcard_getFeecardtocard';
  static const String cardToCardTransferConfirm = 'trcard_loadCardToCard';
  static const String downloadTransactionStatement = 'iban_statment';

  //card section
  static const String cardList = 'trcard_getListCard';
  static const String cardOrderType = 'trcard_getOrdertype';
  static const String cardType = 'trcard_getCardType';
  static const String cardServiceFee = 'trcard_getCardServiceFee';
  static const String cardOrderConfirm = 'trcard_orderCard';
  static const String cardDetails = 'trcard_getCarddetail';
  static const String cardActiveDetails = 'trcard_activateCard';
  static const String cardSetting = 'trcard_cardSetting';
  static const String cardBlockUnblock = 'trcard_blockUnblock';
  static const String cardReplace = 'trcard_replace';
  static const String cardIbanList = 'trcard_getAlliban';
  static const String cardTopupAmount = 'trcard_getLoadcardFee';
  static const String cardTopupConfirm = 'trcard_confirmLoadCard';

  //kyc section
  static const String kycCreateStatus = 'akyc_createApplicationapp';
  static const String kycGetUserAppStatus = 'akyc_get_user_app_status';
  static const String kycDocumentType = 'akyc_documentType';
  static const String kycIdVerify = 'akyc_uploadIdDocument';
  static const String kycAddressVerify = 'akyc_uploadAddressDocument';
  static const String kycUserImage = 'akyc_readIddocument';
  static const String kycFaceVerify = 'akyc_uploadProfile';
  static const String kycSubmit = 'akyc_submitForm';

  //crypto stake
  static const String stakeRequest = 'stake_request';
  static const String stakeOverview = 'stake_log';
  static const String stakeProfitLog = 'stake_profitlogs';
  static const String stakeStop = 'stake_stop';
  static const String stakeFeeBalance = 'stake_getfeebalance';
  static const String stakeOrder = 'stake_order';
  static const String stakeConfirm = 'stake_confirm';
  static const String stakeCustomPeriod = 'stake_customperiod';
  static const String ibanGetCustomAccount = 'iban_getcustomAccount';

  //change password
  static const String changePassword = 'iban_changePassword';
  static const String changePasswordOtp = 'iban_confirmchangePassword';

  /*new api system with sumsub section*/
  static const String getUserAppStatus = 'iban_getStatusoct';
  static const String userSignupAccount = 'sdkkyc_signupemail';
  static const String userSignupOnboardProfile = 'sdkkyc_onboardProfile';
  static const String userSignupEmailVerification = 'sdkkyc_verifyemail';
  static const String refreshSumSubToken = 'sdkkyc_sumsubRefreshToken';
  static const String userLoginAccount = 'iban_appsignin';
  static const String userLoginVerify = 'iban_verifyaccount';

  static const String userKycCheckStatus = 'sdkkyc_checkKycstatus';
  static const String kycUploadIdDoc = 'sdkkyc_uploadIdDocument';
  static const String kycUploadAddressDoc = 'sdkkyc_uploadAddressDocument';
  static const String kycFaceVerifyImage = 'sdkkyc_readIddocument';
  static const String kycFaceVerifyDoc = 'sdkkyc_uploadProfile';
  static const String kycSubmitData = 'sdkkyc_submitForm';
  static const String kycSubmitDataIsWallet = 'sdkkyc_IdProofsubmitForm';

  //forgot password section
  static const String forgotPasswordApi = 'sdkkyc_forgotPassword';
  static const String forgotPasswordVerifyOtpApi = 'sdkkyc_verifyotp';
  static const String forgotPasswordBiometricStatusApi =
      'sdkkyc_updateForgotpasswordBioStatus';
  static const String updatePasswordApi = 'sdkkyc_updatePassword';

  static const String userLoginBiometric = 'iban_updateBioStatus';

  /*pos section*/
  static const String checkPosModule = 'cpos_checkpos';
  static const String cryptoCheckList = 'cpos_listpos';
  static const String createCryptoStore = 'cpos_createpos';
  static const String coinList = 'cpos_coinlist';
  static const String createQr = 'cpos_createQR';
  static const String getCryptoTransactionInfo = 'cpos_getpaymentinfo';
  static const String cryptoOrderCancel = 'cpos_cancel';
  static const String storeTransactionLogs = 'cpos_transactionLogs';
  static const String transactionDetails = 'cpos_transactionLogs';
  static const String remotePayment = 'cpos_remotePayment';

  //new
  static const String cryptoGatewayCurrencyList = 'cpos_getAllcurrency';

  //dynamic beneficiary section
  static const String swiftDepositData = 'cycloud_getSwiftdetail';
  static const String swiftCountry = 'cycloud_getcurrencyandcountry';
  static const String dynamicBeneficiaryFieldList = 'cycloud_getBankfields';
  static const String dynamicAddBeneficiary = 'cycloud_addBeneficary';

  static const String getSwiftSendMoneyData = 'cycloud_swiftmultipayment';
  static const String sdkKycUdatetc = 'iban_updatetc';

  //deposit section
  static const String depositAccountDetails = 'cycloud_accountdetails';
  static const String convertCurrencyList =
      'cycloud_getAvailablecurrencyforconversion';
  static const String currencyRate = 'cycloud_getCurrencyRate';

  static const String currencyConvertConfirm = 'cycloud_buyconvert';
  static const String termsAndConditionApi = 'iban_gettcpdf';

  /*cdg masternode section*/
  static const String cdgDeviceList = 'cdgs_listdevice';
  static const String cdgAccounts = 'cdgs_accounts';
  static const String cdgOrder = 'cdgs_order';
  static const String cdgDashboard = 'cdgs_dashboard';
  static const String cdgProfitLog = 'cdgs_profitLogs';
  static const String cdgSendInvite = 'cdgs_sendinvite';
  static const String cdgCheckQrCode = 'cdgs_checkqrcode';
  static const String cdgDeviceActive = 'cdgs_activate';
  static String cdgConvert = 'cdgs_convert';
  static String cdgListForStakeApi = 'cdgs_listForstake';
  static String cdgStakeGetOverview = 'cdgs_getOverview';
  static String cdgStakePayNow = 'cdgs_paynow';
  static String cdgUnStakeApi = 'cdgs_unstake';

  //profile section new pay with
  static String payWith = 'iban_updateFeesetiing';

  /*wallet transfer*/
  static const String walletTransferIbanList =
      'cycloud_getAccountListformovebalance';
  static const String walletTransferMove = 'cycloud_moveBalance';

  //update doc section
  static String updateDocCheckStatus = 'iban_checkreKycstatus';

  static const String updateDocUploadApi = 'iban_upload_kyc_document';

  //device info
  static const String codegoRequestForSessionDataApi = 'sendevicedetail';

  ///////////////////////////////////////////////////////////////////

  static const String endPointGetuserstatus = 'iban_get_user_app_status';
}

enum HttpMethod { Get, Post, Put, Patch, Delete }

class NetworkManager {
  static final NetworkManager _singleton = NetworkManager._internal();

  factory NetworkManager() {
    return _singleton;
  }

  NetworkManager._internal();

  Dio dio = Dio();

  void setDioOptions() {
    dio.options.contentType = Headers.jsonContentType;
    dio.options.headers = {
      'User-Agent': AppConfig.userAgent,
    };
  }

  Future<Response?> callApi({
    required HttpMethod method,
    required String urlEndPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, dynamic>? body,
    FormData? formData,
    bool isMedia = false,
    String? customUserAgent, // Add a parameter for custom User-Agent
  }) async {
    setDioOptions();

    // Add custom User-Agent if provided
    if (customUserAgent != null) {
      dio.options.headers['User-Agent'] = customUserAgent;
    }

    var requestURL = AppConfig.baseUrl + urlEndPoint;
    debugPrint("Request URL: $requestURL");

    if (await ConnectionStatusSingleton.getInstance().isConnectedToInternet()) {
      try {
        switch (method) {
          case HttpMethod.Get:
            return await dio.get(
              requestURL,
              queryParameters: queryParameters,
              options: options,
            );
          case HttpMethod.Post:
            return await dio.post(
              requestURL,
              queryParameters: queryParameters,
              options: options,
              data: isMedia ? formData : body,
            );
          case HttpMethod.Put:
            return await dio.put(
              requestURL,
              queryParameters: queryParameters,
              options: options,
              data: formData,
            );
          case HttpMethod.Patch:
            return await dio.patch(
              requestURL,
              queryParameters: queryParameters,
              options: options,
              data: formData,
            );
          case HttpMethod.Delete:
            return await dio.delete(
              requestURL,
              options: options,
            );
        }
      } on DioError catch (error) {
        Map<String, dynamic> errorResponse = error.response!.data;
        return Response(
          data: errorResponse,
          statusCode: error.response!.statusCode,
          requestOptions: error.requestOptions,
        );
      }
    } else {
      debugPrint("No internet connection.");
      Application.navKey.currentState!.push(
        MaterialPageRoute(builder: (context) => NoNetworkConnectionScreen()),
      );
      return Response(
        requestOptions: RequestOptions(path: requestURL),
      );
    }
    return null;
  }
}
