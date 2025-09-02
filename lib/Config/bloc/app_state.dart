part of 'app_bloc.dart';

@immutable
class AppState {
  bool? isloading;

  AppState({this.isloading});

  factory AppState.init() {
    return AppState(isloading: false);
  }
}

class AuthenticationUninitialized extends AppState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AppState {
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthenticationUnauthenticated extends AppState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AppState {
  @override
  String toString() => 'AuthenticationLoading';
}

class BaseURLNotSet extends AppState {
  @override
  String toString() => 'BaseURLNotSet';
}

class WelcomeScreenState extends AppState {
  @override
  String toString() => 'WelcomeScreenState';
}

class UpdateappState extends AppState {
  @override
  String toString() => 'UpdateappState';
}

class locationdenied extends AppState {
  @override
  String toString() => 'locationdenied';
}

class MobileVerificationScreenState extends AppState {
  @override
  String toString() => 'MobileVerificationScreenState';
}

class PersonalDataScreenState extends AppState {
  @override
  String toString() => 'PersonalDataScreenState';
}

class EmailVerificationScreenState extends AppState {
  @override
  String toString() => 'EmailVerificationScreenState';
}

class ProfileImageScreenState extends AppState {
  @override
  String toString() => 'ProfileImageScreenState';
}

class Uploadsource extends AppState {
  @override
  String toString() => 'Uploadsource';
}

class Pendingstatus extends AppState {
  @override
  String toString() => 'Pendingstatus';
}

class Rejectedstatus extends AppState {
  @override
  String toString() => 'Rejectedstatus';
}

class FirstKYCScreenState extends AppState {
  @override
  String toString() => 'FirstKYCScreenState';
}

class ResendkycScreenState extends AppState {
  @override
  String toString() => 'ResendkycScreenState';
}

class PendingKycScreenState extends AppState {
  @override
  String toString() => 'PendingKycScreenState';
}

class RejectedkycScreenState extends AppState {
  @override
  String toString() => 'RejectedkycScreenState';
}

class VideoDocumentScreenState extends AppState {
  @override
  String toString() => 'VideoDocumentScreenState';
}

class PendingProfileScreenState extends AppState {
  @override
  String toString() => 'PendingProfileScreenState';
}

class DashboardScreenState extends AppState {
  @override
  String toString() => 'DashboardScreenState';
}

class SetPinScreenState extends AppState {
  @override
  String toString() => 'SetPinScreenState';
}

class OpenScreenstate extends AppState {
  @override
  String toString() => 'OpenScreenstate';
}

class planScreenState extends AppState {
  @override
  String toString() => 'planScreenState';
}

class chatscreenState extends AppState {
  @override
  String toString() => 'chatscreenState';
}

class GetUserPinScreenState extends AppState {
  @override
  String toString() => 'GetUserPinScreenState';
}

class NoNetworkState extends AppState {
  @override
  String toString() => 'NoNetworkState';
}

class Maintenance extends AppState {
  @override
  String toString() => 'Maintenance';
}

class UserAppStatusState extends AppState {
  @override
  String toString() => 'WelcomeScreenState';
}

class LockScreenState extends AppState {
  @override
  String toString() => 'lockScreen';
}

class UpdateDocScreenState extends AppState {
  @override
  String toString() => 'updateDocScreenState';
}


class SignUpUserInfoPage1ScreenState extends AppState {
  @override
  String toString() => 'signUpUserInfoPage1Screen';
}