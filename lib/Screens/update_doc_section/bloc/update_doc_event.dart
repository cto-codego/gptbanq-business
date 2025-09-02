part of 'update_doc_bloc.dart';

@immutable
abstract class UpdateDocEvent {}

//kyc section

class KycStatusCheckEvent extends UpdateDocEvent {}

class KycGetUserStatusEvent extends UpdateDocEvent {}

class KycCreateEvent extends UpdateDocEvent {}

class KycDocumentTypeEvent extends UpdateDocEvent {}

class KycIdVerifyEvent extends UpdateDocEvent {
  String uniqueId, docTypeStatus;

  KycIdVerifyEvent({required this.uniqueId, required this.docTypeStatus});
}

class KycAddressVerifyEvent extends UpdateDocEvent {
  String uniqueId, docTypeStatus;

  KycAddressVerifyEvent({required this.uniqueId, required this.docTypeStatus});
}

class KycGetUserImageEvent extends UpdateDocEvent {
  String uniqueId;

  KycGetUserImageEvent({required this.uniqueId});
}

class KycFaceVerifyEvent extends UpdateDocEvent {
  final String image, uniqueId, docTypeStatus;

  KycFaceVerifyEvent( {required this.image, required this.uniqueId, required this.docTypeStatus,});
}

class KycSubmitEvent extends UpdateDocEvent {}

class KycSubmitIsWalletEvent extends UpdateDocEvent {}

class UserKycCheckStatusEvent extends UpdateDocEvent {}

//update doc section

class UpdateDocCheckStatusEvent extends UpdateDocEvent {}