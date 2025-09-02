import 'dart:convert';
import 'dart:io';

import 'package:gptbanqbusiness/Models/user_model.dart';
import 'package:gptbanqbusiness/constant_string/constant_strings.dart';
import 'package:gptbanqbusiness/utils/secure_st_manager.dart';
import 'package:path_provider/path_provider.dart';

class UserDataManager {
  static final UserDataManager _singleton = UserDataManager._internal();

  factory UserDataManager() {
    return _singleton;
  }

  UserDataManager._internal();

  void saveUserId(String userId) async {
    SecureSt()
        .getInstance()
        .write(key: ConstantStrings.USER_ID_KEY, value: userId);
  }

  void savechatid(String chatid) async {
    SecureSt().getInstance().write(key: 'chatid', value: chatid);
  }

  Future<String> getchatid() async {
    String? chatid = await SecureSt().getInstance().read(key: 'chatid');
    return chatid!;
  }

  Future<String> getUserId() async {
    String? userId =
        await SecureSt().getInstance().read(key: ConstantStrings.USER_ID_KEY) ??
            '';
    return userId;
  }

  void saveMobileNumber(String mobileNumber) async {
    SecureSt()
        .getInstance()
        .write(key: ConstantStrings.MOBILE_NUMBER_KEY, value: mobileNumber);
  }

  Future<String> getMobileNumber() async {
    String? mobileNumber = await SecureSt()
        .getInstance()
        .read(key: ConstantStrings.MOBILE_NUMBER_KEY);
    return mobileNumber!;
  }

  void saveToken(String token) async {
    SecureSt()
        .getInstance()
        .write(key: ConstantStrings.USER_ID_TOKEN, value: token);
  }

  Future<String> getToken() async {
    String? token =
        await SecureSt().getInstance().read(key: ConstantStrings.USER_ID_TOKEN);
    return token!;
  }

  void saveImei(String Imei) async {
    SecureSt().getInstance().write(key: 'fixedImei', value: Imei);
  }

  Future<String> getImei() async {
    String mobileNumber =
        await SecureSt().getInstance().read(key: 'fixedImei') ?? '';
    return mobileNumber;
  }

  void savePin(String token) async {
    SecureSt().getInstance().write(key: ConstantStrings.PINK_KEY, value: token);
  }

  Future<String> getPin() async {
    String? pin =
        await SecureSt().getInstance().read(key: ConstantStrings.PINK_KEY);
    return pin!;
  }

  void saveIsUsingBiometricAuth(String isUsingBiometricAuth) async {
    SecureSt().getInstance().write(
        key: ConstantStrings.USING_BIOMETRIC_AUTH, value: isUsingBiometricAuth);
  }

  Future<String> getIsUsingBiometricAuth() async {
    String usingBiometricAuth = await SecureSt()
            .getInstance()
            .read(key: ConstantStrings.USING_BIOMETRIC_AUTH) ??
        '';
    return usingBiometricAuth;
  }

  void saveMobileNumberCountryId(String mobileNumberCountryId) async {
    SecureSt().getInstance().write(
        key: ConstantStrings.MOBILE_NUMBER_COUNTRY_ID_KEY,
        value: mobileNumberCountryId);
  }

  Future<String> getMobileNumberCountryId() async {
    String? mobileNumberCountryId = await SecureSt()
        .getInstance()
        .read(key: ConstantStrings.MOBILE_NUMBER_COUNTRY_ID_KEY);
    return mobileNumberCountryId!;
  }

  void saveLoginResponse(UserModel loginResModel) async {}

  Future<UserModel> getUserDataModel() async {
    UserModel? savedUserData = UserModel();
    savedUserData = null;

    return savedUserData!;
  }

  Future<void> removeUserData() async {}

  //gift card section

  void giftCardImageSave(String giftCardImage) async {
    SecureSt().getInstance().write(key: 'cardImage', value: giftCardImage);
  }

  Future<String> getGiftCardImage() async {
    String cardImage =
        await SecureSt().getInstance().read(key: 'cardImage') ?? '';
    return cardImage;
  }

  void giftCardIbanSave(String selectedIban) async {
    SecureSt().getInstance().write(key: 'selectedIban', value: selectedIban);
  }

  Future<String> getGiftCardIban() async {
    String selectedIban =
        await SecureSt().getInstance().read(key: 'selectedIban') ?? '';
    return selectedIban;
  }

  void giftCardSave(String selectedCard) async {
    SecureSt().getInstance().write(key: 'selectedCard', value: selectedCard);
  }

  Future<String> getGiftCard() async {
    String selectedCard =
        await SecureSt().getInstance().read(key: 'selectedCard') ?? '';
    return selectedCard;
  }

  void giftCardAmountSave(String selectedAmount) async {
    SecureSt()
        .getInstance()
        .write(key: 'selectedAmount', value: selectedAmount);
  }

  Future<String> getGiftCardAmount() async {
    String selectedAmount =
        await SecureSt().getInstance().read(key: 'selectedAmount') ?? '';
    return selectedAmount;
  }

  void giftCardOrderConfirm(String orderConfirm) async {
    SecureSt().getInstance().write(key: 'orderConfirm', value: orderConfirm);
  }

  Future<String> getGiftCardOrderConfirm() async {
    String orderConfirm =
        await SecureSt().getInstance().read(key: 'orderConfirm') ?? '';
    return orderConfirm;
  }

  void giftCardDeleteCardIdSave(String deleteCardId) async {
    SecureSt().getInstance().write(key: 'deleteCardId', value: deleteCardId);
  }

  Future<String> getGiftCardDeleteCardId() async {
    String deleteCardId =
        await SecureSt().getInstance().read(key: 'deleteCardId') ?? '';
    return deleteCardId;
  }

  void giftCardShareEmailSave(String email) async {
    SecureSt().getInstance().write(key: 'email', value: email);
  }

  Future<String> getGiftCardShareEmail() async {
    String email = await SecureSt().getInstance().read(key: 'email') ?? '';
    return email;
  }

  void giftCardShareNameSave(String name) async {
    SecureSt().getInstance().write(key: 'name', value: name);
  }

  Future<String> getGiftCardShareName() async {
    String name = await SecureSt().getInstance().read(key: 'name') ?? '';
    return name;
  }

  void kycDocTypeSave(String kycDocType) async {
    SecureSt().getInstance().write(key: 'kycDocType', value: kycDocType);
  }

  Future<String> getKycDocType() async {
    String kycDocType =
        await SecureSt().getInstance().read(key: 'kycDocType') ?? '';
    return kycDocType;
  }

  void idCardFrontImageSave(String imagePath) async {
    await SecureSt()
        .getInstance()
        .write(key: 'idCardFrontsPath', value: imagePath);
  }

  // Retrieve the path of the front image
  Future<String> getIdCardFrontImageCheck() async {
    String imagePath =
        await SecureSt().getInstance().read(key: 'idCardFrontsPath') ?? '';
    return imagePath;
  }

  // Clear the path of the front image
  Future<void> clearIdCardFrontImage() async {
    await SecureSt().getInstance().delete(key: 'idCardFrontsPath');
  }

  // Save the path of the back image
  void idCardBackImageSave(String imagePath) async {
    await SecureSt()
        .getInstance()
        .write(key: 'idCardBackPath', value: imagePath);
  }

  // Retrieve the path of the back image
  Future<String> getIdCardBackImage() async {
    String imagePath =
        await SecureSt().getInstance().read(key: 'idCardBackPath') ?? '';
    return imagePath;
  }

  // Clear the path of the back image
  Future<void> clearIdCardBackImage() async {
    await SecureSt().getInstance().delete(key: 'idCardBackPath');
  }

  // Save the path of the passport image
  void passportImageSave(String imagePath) async {
    await SecureSt()
        .getInstance()
        .write(key: 'passportImagePath', value: imagePath);
  }

  // Retrieve the path of the passport image
  Future<String> getPassportImage() async {
    String imagePath =
        await SecureSt().getInstance().read(key: 'passportImagePath') ?? '';
    return imagePath;
  }

  Future<void> clearPassportImage() async {
    await SecureSt().getInstance().delete(key: 'passportImage');
  }

  // Save the path of the passport image
  void addressImageSave(String imagePath) async {
    await SecureSt()
        .getInstance()
        .write(key: 'addressImagePath', value: imagePath);
  }

  // Retrieve the path of the passport image
  Future<String> getAddressImage() async {
    String imagePath =
        await SecureSt().getInstance().read(key: 'addressImagePath') ?? '';
    return imagePath;
  }

  Future<void> clearAddressImage() async {
    await SecureSt().getInstance().delete(key: 'addressImage');
  }

  void userImageSave(List<int> imageData) async {
    String base64Image5 = base64Encode(imageData);

    // Save the base64 encoded image to secure storage
    SecureSt().getInstance().write(key: 'userImage', value: base64Image5);
  }

  Future<String> getUserImage() async {
    String base64Image5 =
        await SecureSt().getInstance().read(key: 'userImage') ?? '';

    return base64Image5;
  }

  Future<void> clearUserImageImage() async {
    await SecureSt().getInstance().delete(key: 'userImage');
  }

  void similarityUserImageSave(String similarityUserImage) async {
    SecureSt()
        .getInstance()
        .write(key: 'similarityUserImage', value: similarityUserImage);
  }

  Future<String> getSimilarityUserImageData() async {
    String similarityUserImage =
        await SecureSt().getInstance().read(key: 'similarityUserImage') ?? '';
    return similarityUserImage;
  }

  Future<void> clearSimilarityUserImage() async {
    await SecureSt().getInstance().delete(key: 'similarityUserImage');
  }

  void similaritySave(String similarity) async {
    SecureSt().getInstance().write(key: 'similarity', value: similarity);
  }

  Future<String> getSimilarityData() async {
    String similarity =
        await SecureSt().getInstance().read(key: 'similarity') ?? '';
    return similarity;
  }

  Future<void> clearSimilarity() async {
    await SecureSt().getInstance().delete(key: 'similarity');
  }

  void similarityImageSave(String similarityImage) async {
    SecureSt()
        .getInstance()
        .write(key: 'similarityImage', value: similarityImage);
  }

  Future<String> getSimilarityImageData() async {
    String similarityImage =
        await SecureSt().getInstance().read(key: 'similarityImage') ?? '';
    return similarityImage;
  }

  Future<void> clearSimilarityImage() async {
    await SecureSt().getInstance().delete(key: 'similarityImage');
  }

  void idProofStatusSave(String idProofStatus) async {
    SecureSt().getInstance().write(key: 'idProofStatus', value: idProofStatus);
  }

  Future<String> getIdProofStatus() async {
    String idProofStatus =
        await SecureSt().getInstance().read(key: 'idProofStatus') ?? '';
    return idProofStatus;
  }

  void idAddressProofStatusSave(String idAddressProof) async {
    SecureSt()
        .getInstance()
        .write(key: 'idAddressProof', value: idAddressProof);
  }

  Future<String> getIdAddressProofStatus() async {
    String idAddressProof =
        await SecureSt().getInstance().read(key: 'idAddressProof') ?? '';
    return idAddressProof;
  }

  void idSelfieProofStatusSave(String idSelfieProof) async {
    SecureSt().getInstance().write(key: 'idSelfieProof', value: idSelfieProof);
  }

  Future<String> getIdSelfieProofStatus() async {
    String idSelfieProof =
        await SecureSt().getInstance().read(key: 'idSelfieProof') ?? '';
    return idSelfieProof;
  }

  void cardTypeSave(String isCardType) async {
    SecureSt().getInstance().write(key: 'isCardType', value: isCardType);
  }

  Future<String> getCardType() async {
    String isCardType =
        await SecureSt().getInstance().read(key: 'isCardType') ?? '';
    return isCardType;
  }

  void cardSave(String card) async {
    SecureSt().getInstance().write(key: 'card', value: card);
  }

  Future<String> getCard() async {
    String card = await SecureSt().getInstance().read(key: 'card') ?? '';
    return card;
  }

  void userAddressSave(String address) async {
    SecureSt().getInstance().write(key: 'address', value: address);
  }

  Future<String> getUserAddress() async {
    String address = await SecureSt().getInstance().read(key: 'address') ?? '';
    return address;
  }

  void userCitySave(String city) async {
    SecureSt().getInstance().write(key: 'city', value: city);
  }

  Future<String> getUserCity() async {
    String city = await SecureSt().getInstance().read(key: 'city') ?? '';
    return city;
  }

  void userPostalCodeSave(String postalCode) async {
    SecureSt().getInstance().write(key: 'postalCode', value: postalCode);
  }

  Future<String> getUserPostalCode() async {
    String postalCode =
        await SecureSt().getInstance().read(key: 'postalCode') ?? '';
    return postalCode;
  }

  void userCountySave(String country) async {
    SecureSt().getInstance().write(key: 'country', value: country);
  }

  Future<String> getUserCountry() async {
    String country = await SecureSt().getInstance().read(key: 'country') ?? '';
    return country;
  }

  void cardShippingCostSave(String cardShippingCost) async {
    SecureSt()
        .getInstance()
        .write(key: 'cardShippingCost', value: cardShippingCost);
  }

  Future<String> getCardShippingCost() async {
    String cardShippingCost =
        await SecureSt().getInstance().read(key: 'cardShippingCost') ?? '';
    return cardShippingCost;
  }

  void cardholderSave(String cardHolder) async {
    SecureSt().getInstance().write(key: 'cardHolder', value: cardHolder);
  }

  Future<String> getCardHolder() async {
    String cardHolder =
        await SecureSt().getInstance().read(key: 'cardHolder') ?? '';
    return cardHolder;
  }

  void cardIdSave(String cardId) async {
    SecureSt().getInstance().write(key: 'cardId', value: cardId);
  }

  Future<String> getCardId() async {
    String cardId = await SecureSt().getInstance().read(key: 'cardId') ?? '';
    return cardId;
  }

  void cardDailyLimitSave(String dailyLimit) async {
    SecureSt().getInstance().write(key: 'dailyLimit', value: dailyLimit);
  }

  Future<String> getCardDailyLimit() async {
    String dailyLimit =
        await SecureSt().getInstance().read(key: 'dailyLimit') ?? '';
    return dailyLimit;
  }

  void cardContactlessLimitSave(String contactlessLimit) async {
    SecureSt()
        .getInstance()
        .write(key: 'contactlessLimit', value: contactlessLimit);
  }

  Future<String> getCardContactlessLimit() async {
    String contactlessLimit =
        await SecureSt().getInstance().read(key: 'contactlessLimit') ?? '';
    return contactlessLimit;
  }

  void cardOnlineSave(String online) async {
    SecureSt().getInstance().write(key: 'online', value: online);
  }

  Future<String> getCardOnline() async {
    String online = await SecureSt().getInstance().read(key: 'online') ?? '0';
    return online;
  }

  void cardContactlessSave(String contactless) async {
    SecureSt().getInstance().write(key: 'contactless', value: contactless);
  }

  Future<String> getCardContactless() async {
    String contactless =
        await SecureSt().getInstance().read(key: 'contactless') ?? '0';
    return contactless;
  }

  void cardRecurringSave(String recurring) async {
    SecureSt().getInstance().write(key: 'recurring', value: recurring);
  }

  Future<String> getCardRecurring() async {
    String recurring =
        await SecureSt().getInstance().read(key: 'recurring') ?? '0';
    return recurring;
  }

  void pinBlockUnblockSave(String pinBlockUnblock) async {
    SecureSt()
        .getInstance()
        .write(key: 'pinBlockUnblock', value: pinBlockUnblock);
  }

  Future<String> getPinBlockUnblock() async {
    String pinBlockUnblock =
        await SecureSt().getInstance().read(key: 'pinBlockUnblock') ?? '0';
    return pinBlockUnblock;
  }

  void cardBlockUnblockStatusSave(String cardBlockUnblock) async {
    SecureSt()
        .getInstance()
        .write(key: 'cardBlockUnblock', value: cardBlockUnblock);
  }

  Future<String> getCardBlockUnblockStatus() async {
    String cardBlockUnblock =
        await SecureSt().getInstance().read(key: 'cardBlockUnblock') ?? '';
    return cardBlockUnblock;
  }

  void prepaidCardAmountSave(String amount) async {
    SecureSt().getInstance().write(key: 'amount', value: amount);
  }

  Future<String> getPrepaidCardAmount() async {
    String amount = await SecureSt().getInstance().read(key: 'amount') ?? '';
    return amount;
  }

  void cardNumberShowSave(String? show) async {
    SecureSt().getInstance().write(key: "show", value: show);
  }

  Future<String> getCardNumberShow() async {
    String show = await SecureSt().getInstance().read(key: 'show') ?? 'false';
    return show;
  }

  void cardIbanSelectSave(String cardIban) async {
    SecureSt().getInstance().write(key: 'cardIban', value: cardIban);
  }

  Future<String> getCardIbanSelected() async {
    String cardIban =
        await SecureSt().getInstance().read(key: 'cardIban') ?? '';
    return cardIban;
  }

  void addCardBeneficiaryEmailSave(String email) async {
    SecureSt().getInstance().write(key: 'email', value: email);
  }

  Future<String> getAddCardBeneficiaryEmail() async {
    String email = await SecureSt().getInstance().read(key: 'email') ?? '';
    return email;
  }

  void addCardBeneficiaryCardSave(String card) async {
    SecureSt().getInstance().write(key: 'card', value: card);
  }

  Future<String> getAddCardBeneficiaryCard() async {
    String card = await SecureSt().getInstance().read(key: 'card') ?? '';
    return card;
  }

  void cardBeneficiaryIdSave(String id) async {
    SecureSt().getInstance().write(key: 'id', value: id);
  }

  Future<String> getCardBeneficiaryId() async {
    String id = await SecureSt().getInstance().read(key: 'id') ?? '';
    return id;
  }

  void cardToCardTransferAmountSave(String amount) async {
    SecureSt().getInstance().write(key: 'amount', value: amount);
  }

  Future<String> getCardToCardTransferAmount() async {
    String amount = await SecureSt().getInstance().read(key: 'amount') ?? '';
    return amount;
  }

  void cardToCardTransferSenderIdSave(String senderId) async {
    SecureSt().getInstance().write(key: 'senderId', value: senderId);
  }

  Future<String> getCardToCardTransferSenderId() async {
    String senderId =
        await SecureSt().getInstance().read(key: 'senderId') ?? '';
    return senderId;
  }

  void activeCardNumberSave(String cardNumber) async {
    SecureSt().getInstance().write(key: 'cardNumber', value: cardNumber);
  }

  Future<String> getActiveCardNumber() async {
    String cardNumber =
        await SecureSt().getInstance().read(key: 'cardNumber') ?? '';
    return cardNumber;
  }

  void setUserIbanSave(String? userIban) async {
    SecureSt().getInstance().write(key: 'userIban', value: userIban);
  }

  Future<String> getUserIban() async {
    String userIban =
        await SecureSt().getInstance().read(key: 'userIban') ?? '';
    return userIban;
  }

  // Clear iban account
  Future<void> clearUserIbanAccount() async {
    print("useriban deleted");
    await SecureSt().getInstance().delete(key: 'userIban');
  }

  void setFromDateSave(String fromDate) async {
    SecureSt().getInstance().write(key: 'fromDate', value: fromDate);
  }

  Future<String> getFromDate() async {
    String fromDate =
        await SecureSt().getInstance().read(key: 'fromDate') ?? '';
    return fromDate;
  }

  void setToDateSave(String toDate) async {
    SecureSt().getInstance().write(key: 'toDate', value: toDate);
  }

  Future<String> getToDate() async {
    String toDate = await SecureSt().getInstance().read(key: 'toDate') ?? '';
    return toDate;
  }

  void dashboardIbanSave(String ibanData) async {
    SecureSt().getInstance().write(key: 'ibanData', value: ibanData);
  }

  Future<String> getDashboardIban() async {
    String ibanData =
        await SecureSt().getInstance().read(key: 'ibanData') ?? '';
    return ibanData;
  }

  Future<void> clearUserIbanData() async {
    print("user iban data deleted");
    await SecureSt().getInstance().delete(key: 'ibanData');
  }

  void userSumSubTokenSave(String sumSubToken) async {
    SecureSt().getInstance().write(key: 'sumSubToken', value: sumSubToken);
  }

  Future<String> getUserSumSubToken() async {
    String sumSubToken =
        await SecureSt().getInstance().read(key: 'sumSubToken') ?? '';
    return sumSubToken;
  }

  void statusMessageSave(String statusMessage) async {
    SecureSt().getInstance().write(key: 'statusMessage', value: statusMessage);
  }

  Future<String> getStatusMessage() async {
    String statusMessage =
        await SecureSt().getInstance().read(key: 'statusMessage') ?? '';
    return statusMessage;
  }

  void setUserEmailSave(String email) async {
    SecureSt().getInstance().write(key: 'email', value: email);
  }

  Future<String> getUserEmail() async {
    String email = await SecureSt().getInstance().read(key: 'email') ?? '';
    return email;
  }

  void forgotPassUniqueIdSave(String uniqueId) async {
    SecureSt().getInstance().write(key: 'uniqueId', value: uniqueId);
  }

  Future<String> getForgotPassUniqueId() async {
    String uniqueId =
        await SecureSt().getInstance().read(key: 'uniqueId') ?? '';
    return uniqueId;
  }

  Future<void> clearForgotPassUniqueId() async {
    print("user uniqueId deleted");
    await SecureSt().getInstance().delete(key: 'uniqueId');
  }

  void forgotPassUserIdSave(String userId) async {
    SecureSt().getInstance().write(key: 'userId', value: userId);
  }

  Future<String> getForgotPassUserId() async {
    String userId = await SecureSt().getInstance().read(key: 'userId') ?? '';
    return userId;
  }

  Future<void> clearForgotPassUserId() async {
    print("user user id deleted");
    await SecureSt().getInstance().delete(key: 'userId');
  }

  void darkButtonColorSave(String darkButton) async {
    SecureSt().getInstance().write(key: 'darkButton', value: darkButton);
  }

  Future<String> getDarkButtonColor() async {
    String darkButton =
        await SecureSt().getInstance().read(key: 'darkButton') ?? '';
    return darkButton;
  }

  Future<void> clearDarkButtonColor() async {
    await SecureSt().getInstance().delete(key: 'darkButton');
  }

  void lightButtonColorSave(String lightButton) async {
    SecureSt().getInstance().write(key: 'lightButton', value: lightButton);
  }

  Future<String> getLightButtonColor() async {
    String lightButton =
        await SecureSt().getInstance().read(key: 'lightButton') ?? '';
    return lightButton;
  }

  Future<void> clearLightButtonColor() async {
    await SecureSt().getInstance().delete(key: 'lightButton');
  }

  void transferButtonColorSave(String transferButton) async {
    SecureSt()
        .getInstance()
        .write(key: 'transferButton', value: transferButton);
  }

  Future<String> getTransferButtonColor() async {
    String transferButton =
        await SecureSt().getInstance().read(key: 'transferButton') ?? '';
    return transferButton;
  }

  Future<void> clearTransferButtonColor() async {
    await SecureSt().getInstance().delete(key: 'transferButton');
  }

  void depositButtonColorSave(String depositButton) async {
    SecureSt().getInstance().write(key: 'depositButton', value: depositButton);
  }

  Future<String> getDepositButtonColor() async {
    String depositButton =
        await SecureSt().getInstance().read(key: 'depositButton') ?? '';
    return depositButton;
  }

  Future<void> clearDepositButtonColor() async {
    await SecureSt().getInstance().delete(key: 'depositButton');
  }

  void userDeviceInfoSave(String image) async {
    SecureSt().getInstance().write(key: 'userDeviceInfo', value: image);
  }

  Future<String> getUserDeviceInfo() async {
    String userImage =
        await SecureSt().getInstance().read(key: 'userDeviceInfo') ?? '';
    return userImage;
  }

}
