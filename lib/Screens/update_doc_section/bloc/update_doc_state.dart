part of 'update_doc_bloc.dart';

@immutable
class UpdateDocState {
  final bool? isloading;
  final StatusModel? statusModel;

  final KycDocumentTypeModel? kycDocumentTypeModel;
  final KycIdVerifyModel? kycIdVerifyModel;
  final KycAddressVerifyModel? kycAddressVerifyModel;
  final KycFaceVerifyModel? kycFaceVerifyModel;
  final KycSubmitModel? kycSubmitModel;
  final KycGetUserImageModel? kycGetUserImageModel;

  final UserKycCheckStatusModel? userKycCheckStatusModel;

  //update doc section =>
  final UpdateDocCheckModel? updateDocCheckModel;

  UpdateDocState({
    this.isloading,
    this.statusModel,
    this.kycDocumentTypeModel,
    this.kycIdVerifyModel,
    this.kycAddressVerifyModel,
    this.kycFaceVerifyModel,
    this.kycSubmitModel,
    this.kycGetUserImageModel,
    this.userKycCheckStatusModel,
    //new update section
    this.updateDocCheckModel,
  });

  factory UpdateDocState.init() {
    return UpdateDocState(
      isloading: false,
      statusModel: StatusModel(message: '', status: 222),
      kycDocumentTypeModel: KycDocumentTypeModel(status: 222, doc: []),
      kycIdVerifyModel: KycIdVerifyModel(status: 222, message: ''),
      kycAddressVerifyModel: KycAddressVerifyModel(
        status: 222,
        isSubmitForm: 222,
        message: '',
      ),
      kycFaceVerifyModel: KycFaceVerifyModel(status: 222, message: ''),
      kycSubmitModel: KycSubmitModel(status: 222, message: ''),
      kycGetUserImageModel: KycGetUserImageModel(status: 222, profileimage: ''),
      userKycCheckStatusModel: UserKycCheckStatusModel(
          status: 222,
          message: "",
          idproof: 0,
          isSubmit: 0,
          addressproof: 0,
          isWallet: 0,
          selfie: 0),
      updateDocCheckModel: UpdateDocCheckModel(
          status: 222,
          message: "",
          updateDocData: UpdateDocData(
            docStatus: 0,
            docType: "",
            docTypeStatus: 5,
            rejectedReason: "",
            message: "",
          )),
    );
  }

  UpdateDocState update({
    bool? isloading,
    StatusModel? statusModel,
    GetKycUserStatusModel? getKycUserStatusModel,
    KycDocumentTypeModel? kycDocumentTypeModel,
    KycIdVerifyModel? kycIdVerifyModel,
    KycAddressVerifyModel? kycAddressVerifyModel,
    KycFaceVerifyModel? kycFaceVerifyModel,
    KycSubmitModel? kycSubmitModel,
    KycGetUserImageModel? kycGetUserImageModel,
    KycStatusModel? kycStatusModel,
    KycCreateModel? kycCreateModel,
    UserKycCheckStatusModel? userKycCheckStatusModel,

    //update doc section
    UpdateDocCheckModel? updateDocCheckModel,
  }) {
    return UpdateDocState(
      isloading: isloading,
      statusModel: statusModel,
      kycDocumentTypeModel: kycDocumentTypeModel ?? this.kycDocumentTypeModel,
      kycIdVerifyModel: kycIdVerifyModel ?? this.kycIdVerifyModel,
      kycAddressVerifyModel:
          kycAddressVerifyModel ?? this.kycAddressVerifyModel,
      kycFaceVerifyModel: kycFaceVerifyModel ?? this.kycFaceVerifyModel,
      kycSubmitModel: kycSubmitModel ?? this.kycSubmitModel,
      kycGetUserImageModel: kycGetUserImageModel ?? this.kycGetUserImageModel,
      userKycCheckStatusModel:
          userKycCheckStatusModel ?? this.userKycCheckStatusModel,
      updateDocCheckModel: updateDocCheckModel ?? this.updateDocCheckModel,
    );
  }
}
