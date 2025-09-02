part of 'profile_bloc.dart';

@immutable
class ProfileEvent {}

class getprofileEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}

class ChangePasswordEvent extends ProfileEvent {
  String oldPassword, newPassword, confirmPassword;

  ChangePasswordEvent(
      {required this.oldPassword,
      required this.newPassword,
      required this.confirmPassword});
}

class ChangePasswordOtpEvent extends ProfileEvent {
  String otp, requestId;

  ChangePasswordOtpEvent({required this.otp, required this.requestId});
}

class PayWithEvent extends ProfileEvent {
  final int payWith;

  PayWithEvent({required this.payWith});
}
