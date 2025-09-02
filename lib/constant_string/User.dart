class User {
  static String? Name,
      LastName,
      urlweb,
      dob,
      address,
      city,
      postcode,
      email,
      deviceToken,
      Nationality,
      Country,
      CountryNameValue,
      TaxCountry,
      Phonenumber,
      icomesource,
      Gender,
      sameshipping,
      Reciving_country,
      taxCountry,
      Reciving_card_address,
      Reciving_card_city,
      Reciving_zipcode,
      password,
      deviceType,
      taxincome,
      planlink,
      purpose,
      planuniquid,
      currency,
      profileimage;

  static int planpage = 0;
  static int hidepage = 0;
  static int hideinvest = 0;
  static int hidecdg = 0;
  static int showGc = 0;
  static int isEu = 0;
  static int investmentHidepage = 0;
  static int cryptoGatewayHide = 0;
  static int tcInvestment = 0;
  static int tcCdg = 0;
  static int tcCrypto = 0;
  static int isShowConversion = 0;
  static int showAddressProof = 0;
  static int isWallet = 0;
  static String ibanId = '';
  static int isCdgShow = 0;
  static int isCardEu = 0;
  static int updateDocStatus = 0;

  static String EuroBlamce = '';
  static String cryptoBalance = '';
  static String Screen = 'Main';
  static String termsPdf = '';
  static String tccdgpdf = '';


  static String ibanName = '';
  static String ibanLabel = '';

  static String Phonecode = '1';
  static String kycmessage = '';
  static String countryCode = '';
  static String updateUniqueId = '';
  static String updateDocTypeStatus = '';


  static List rejectedaddress = [];
  static List rejectedproffid = [];

  static int? isIban, cardexits;

  static String uniqueIdNotification = '';

  static bool resendkyc = false;
}
