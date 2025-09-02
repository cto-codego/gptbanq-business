part of 'signup_bloc.dart';

@immutable
class SignupState {
  final bool? isloading;
  final Planlinkmodel? planlinkmodel;

  final StatusModel? statusModel;

  final CurrunciesModel? currunciesModel;

  final SignUpResponseModel? signUpResponseModel;

  final SetUserPinResponseModel? setpinModel;

  final IncomeModel? incomeModel;
  final SourceFund? sourceFund;
  final PlansModel? plansModel;
  final UserGetPinModel? userGetPinModel;
  final LoginResponse? loginResponse;
  final GetKycUserStatusModel? getKycUserStatusModel;
  final KycDocumentTypeModel? kycDocumentTypeModel;
  final KycIdVerifyModel? kycIdVerifyModel;
  final KycAddressVerifyModel? kycAddressVerifyModel;
  final KycFaceVerifyModel? kycFaceVerifyModel;
  final KycSubmitModel? kycSubmitModel;
  final KycGetUserImageModel? kycGetUserImageModel;
  final KycStatusModel? kycStatusModel;
  final KycCreateModel? kycCreateModel;

  // LoginModel? loginModel;

  /*new signup section with seon & sumsub*/
  final UserSignupAccountModel? userSignupAccountModel;
  final SignupEmailVerifiedModel? signupEmailVerifiedModel;
  final UserKycCheckStatusModel? userKycCheckStatusModel;
  final LoginEmailVerifiedModel? loginEmailVerifiedModel;

  /*forgot password section*/
  final ForgotPasswordModel? forgotPasswordModel;
  final ForgotPasswordOtpModel? forgotPasswordOtpModel;

  SignupState({
    this.isloading,
    this.statusModel,
    this.currunciesModel,
    this.signUpResponseModel,
    this.setpinModel,
    this.planlinkmodel,
    this.sourceFund,
    this.incomeModel,
    this.plansModel,
    this.userGetPinModel,
    this.loginResponse,
    this.getKycUserStatusModel,
    this.kycDocumentTypeModel,
    this.kycIdVerifyModel,
    this.kycAddressVerifyModel,
    this.kycFaceVerifyModel,
    this.kycSubmitModel,
    this.kycGetUserImageModel,
    this.kycStatusModel,
    this.kycCreateModel,
    this.userSignupAccountModel,
    this.signupEmailVerifiedModel,
    this.userKycCheckStatusModel,
    this.loginEmailVerifiedModel,
    this.forgotPasswordModel,
    this.forgotPasswordOtpModel,
    // this.loginModel,
  });

  factory SignupState.init() {
    return SignupState(
        isloading: false,
        sourceFund: SourceFund(soruceFund: []),
        statusModel: StatusModel(message: '', status: 222),
        currunciesModel: CurrunciesModel(status: 222, wallet: []),
        planlinkmodel: Planlinkmodel(
            businessPriceLink: '', personPriceLink: '', status: 222),
        signUpResponseModel: SignUpResponseModel(),
        incomeModel: IncomeModel(incomeSource: [], status: 222),
        setpinModel:
            SetUserPinResponseModel(status: 222, token: '', userId: ''),
        plansModel: PlansModel(plan: [], status: 222),
        userGetPinModel: UserGetPinModel(),
        loginResponse: LoginResponse(status: 222, message: ''),
        getKycUserStatusModel: GetKycUserStatusModel(
          status: 222,
          version: "",
          message: '',
          locationhide: 222,
          isSetpin: 222,
          sendlink: 222,
        ),
        kycDocumentTypeModel: KycDocumentTypeModel(status: 222, doc: []),
        kycIdVerifyModel: KycIdVerifyModel(status: 222, message: ''),
        kycAddressVerifyModel: KycAddressVerifyModel(
          status: 222,
          isSubmitForm: 222,
          message: '',
        ),
        kycFaceVerifyModel: KycFaceVerifyModel(status: 222, message: ''),
        kycSubmitModel: KycSubmitModel(status: 222, message: ''),
        kycGetUserImageModel:
            KycGetUserImageModel(status: 222, profileimage: ''),
        kycStatusModel: KycStatusModel(
            status: 222,
            version: '',
            locationhide: 222,
            isSetpin: 222,
            sendlink: 222,
            isIdproof: 222,
            isAddressproof: 222,
            isSelfie: 222,
            showAddressProof: 1,
            message: ""),
        kycCreateModel: KycCreateModel(status: 222, message: ''),
        userSignupAccountModel:
            UserSignupAccountModel(status: 222, email: "", message: ""),
        signupEmailVerifiedModel:
            SignupEmailVerifiedModel(status: 222, sumsubtoken: "", message: ""),
        loginEmailVerifiedModel:
            LoginEmailVerifiedModel(status: 222, profileimage: "", message: ""),
        forgotPasswordModel: ForgotPasswordModel(
          status: 222,
          userId: "",
          uniqueId: "",
          message: "",
        ),
        forgotPasswordOtpModel: ForgotPasswordOtpModel(
          status: 222,
          profileimage: "",
          message: "",
          isBiometric: 222,
        ),
        userKycCheckStatusModel: UserKycCheckStatusModel(
            status: 222,
            message: "",
            idproof: 0,
            isSubmit: 0,
            addressproof: 0,
            isWallet: 0,
            selfie: 0));
  }

  SignupState update({
    bool? isloading,
    StatusModel? statusModel,
    CurrunciesModel? currunciesModel,
    LoginResponse? loginResponse,
    SignUpResponseModel? signUpResponseModel,
    SetUserPinResponseModel? setpinModel,
    IncomeModel? incomeModel,
    PlansModel? plansModel,
    SourceFund? sourceFund,
    UserGetPinModel? userGetPinModel,
    Planlinkmodel? planlinkmodel,
    GetKycUserStatusModel? getKycUserStatusModel,
    KycDocumentTypeModel? kycDocumentTypeModel,
    KycIdVerifyModel? kycIdVerifyModel,
    KycAddressVerifyModel? kycAddressVerifyModel,
    KycFaceVerifyModel? kycFaceVerifyModel,
    KycSubmitModel? kycSubmitModel,
    KycGetUserImageModel? kycGetUserImageModel,
    KycStatusModel? kycStatusModel,
    KycCreateModel? kycCreateModel,
    UserSignupAccountModel? userSignupAccountModel,
    SignupEmailVerifiedModel? signupEmailVerifiedModel,
    UserKycCheckStatusModel? userKycCheckStatusModel,
    LoginEmailVerifiedModel? loginEmailVerifiedModel,
    ForgotPasswordModel? forgotPasswordModel,
    ForgotPasswordOtpModel? forgotPasswordOtpModel,

    // LoginModel? loginModel,
  }) {
    return SignupState(
      isloading: isloading,
      statusModel: statusModel,
      sourceFund: sourceFund ?? this.sourceFund,
      planlinkmodel: planlinkmodel ?? planlinkmodel,
      currunciesModel: currunciesModel ?? this.currunciesModel,
      signUpResponseModel: signUpResponseModel ?? signUpResponseModel,
      setpinModel: setpinModel,
      incomeModel: incomeModel ?? this.incomeModel,
      plansModel: plansModel ?? this.plansModel,
      userGetPinModel: userGetPinModel,
      loginResponse: loginResponse,
      getKycUserStatusModel:
          getKycUserStatusModel ?? this.getKycUserStatusModel,
      kycDocumentTypeModel: kycDocumentTypeModel ?? this.kycDocumentTypeModel,
      kycIdVerifyModel: kycIdVerifyModel ?? this.kycIdVerifyModel,
      kycAddressVerifyModel:
          kycAddressVerifyModel ?? this.kycAddressVerifyModel,
      kycFaceVerifyModel: kycFaceVerifyModel ?? this.kycFaceVerifyModel,
      kycSubmitModel: kycSubmitModel ?? this.kycSubmitModel,
      kycGetUserImageModel: kycGetUserImageModel ?? this.kycGetUserImageModel,
      kycStatusModel: kycStatusModel ?? this.kycStatusModel,
      kycCreateModel: kycCreateModel ?? this.kycCreateModel,
      userSignupAccountModel:
          userSignupAccountModel ?? this.userSignupAccountModel,
      signupEmailVerifiedModel:
          signupEmailVerifiedModel ?? this.signupEmailVerifiedModel,
      userKycCheckStatusModel:
          userKycCheckStatusModel ?? this.userKycCheckStatusModel,
      loginEmailVerifiedModel:
          loginEmailVerifiedModel ?? this.loginEmailVerifiedModel,
      forgotPasswordModel: forgotPasswordModel ?? this.forgotPasswordModel,
      forgotPasswordOtpModel:
          forgotPasswordOtpModel ?? this.forgotPasswordOtpModel,
      // loginModel: loginModel ?? this.loginModel,
    );
  }
}
