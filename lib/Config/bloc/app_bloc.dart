import 'package:bloc/bloc.dart';
import 'package:gptbanqbusiness/Models/user_status/user_app_status_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Models/application.dart';
import '../../utils/connectionStatusSingleton.dart';
import '../../utils/connectivity_manager.dart';
import '../../utils/user_data_manager.dart';
import 'app_respotary.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState.init()) {
    on<AppEvent>(mapEventToState);
  }

  final AppRespo appRespo = AppRespo();

  void mapEventToState(AppEvent event, Emitter<AppState> emit) async {
    if (event is UserstatusEvent) {
      // Load colors before any other processing
      await checkNetwork();
      String isBioMetric = await UserDataManager().getIsUsingBiometricAuth();
      Application.isBioMetric = isBioMetric;
      LocalAuthentication localAuthentication = LocalAuthentication();
      bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
      Application.isBiometricsSupported = canCheckBiometrics;

      (await Permission.location.status);

      bool serviceEnabled = await Location().serviceEnabled();

      UserAppStatusModel userAppStatusModel = UserAppStatusModel();

      debugPrint(" a7a ${serviceEnabled.toString()}");

      userAppStatusModel = await appRespo.getUserStatus();
      debugPrint(
          "--------------📍📍📍CHECK USER HIDE STATUS📍📍📍-------------");
      debugPrint(userAppStatusModel.locationhide.toString());
      debugPrint(
          "--------------📍📍📍CHECK USER HIDE STATUS📍📍📍-------------");

      if (userAppStatusModel.locationhide == 0) {
        UserDataManager().darkButtonColorSave(
            userAppStatusModel.button!.appDarkButtonColor.toString());
        UserDataManager().lightButtonColorSave(
            userAppStatusModel.button!.appLightButtonColor.toString());
        UserDataManager().transferButtonColorSave(
            userAppStatusModel.button!.transferButtonColor.toString());
        UserDataManager().depositButtonColorSave(
            userAppStatusModel.button!.depositButtonColor.toString());
        if (serviceEnabled == false) {
          emit(locationdenied());
        } else if (await Permission.location.isRestricted) {
          debugPrint(Permission.location.toString());
          emit(locationdenied());
        } else if (await Permission.location.isDenied) {
          debugPrint(await Permission.location.status.toString());

          emit(locationdenied());
        } else if (await Permission.location.isPermanentlyDenied) {
          emit(locationdenied());
        } else {
          if (ConnectivityManager.isNetworkAvailable) {
            if (userAppStatusModel.status == 0) {
              emit(WelcomeScreenState());
            } else if (userAppStatusModel.status == 1) {
              emit(SignUpUserInfoPage1ScreenState());
            } else if (userAppStatusModel.status == 2) {
              UserDataManager()
                  .statusMessageSave(userAppStatusModel.message.toString());
              emit(FirstKYCScreenState());
            } else if (userAppStatusModel.status == 3) {
              emit(SetPinScreenState());
            } else if (userAppStatusModel.status == 4) {
              emit(GetUserPinScreenState());
            } else if (userAppStatusModel.status == 10) {
              emit(LockScreenState());
            } else if (userAppStatusModel.status == 20) {
              emit(UpdateDocScreenState());
            } else {
              emit(WelcomeScreenState());
            }
          } else if (!await ConnectionStatusSingleton.getInstance()
              .isConnectedToInternet()) {
            emit(NoNetworkState());
          }
        }
      } else {
        if (ConnectivityManager.isNetworkAvailable) {
          UserDataManager()
              .statusMessageSave(userAppStatusModel.message.toString());
          UserDataManager().darkButtonColorSave(
              userAppStatusModel.button!.appDarkButtonColor.toString());
          UserDataManager().lightButtonColorSave(
              userAppStatusModel.button!.appLightButtonColor.toString());
          UserDataManager().transferButtonColorSave(
              userAppStatusModel.button!.transferButtonColor.toString());
          UserDataManager().depositButtonColorSave(
              userAppStatusModel.button!.depositButtonColor.toString());

          if (userAppStatusModel.status == 0) {
            emit(WelcomeScreenState());
          } else if (userAppStatusModel.status == 1) {
            UserDataManager()
                .statusMessageSave(userAppStatusModel.email.toString());

            emit(SignUpUserInfoPage1ScreenState());
          } else if (userAppStatusModel.status == 2) {
            UserDataManager()
                .statusMessageSave(userAppStatusModel.message.toString());
            emit(FirstKYCScreenState());
          } else if (userAppStatusModel.status == 3) {
            emit(SetPinScreenState());
          } else if (userAppStatusModel.status == 4) {
            emit(GetUserPinScreenState());
          } else if (userAppStatusModel.status == 10) {
            emit(LockScreenState());
          } else if (userAppStatusModel.status == 20) {
            emit(UpdateDocScreenState());
          } else {
            emit(WelcomeScreenState());
          }
        } else if (!await ConnectionStatusSingleton.getInstance()
            .isConnectedToInternet()) {
          emit(NoNetworkState());
          UserDataManager().darkButtonColorSave(
              userAppStatusModel.button!.appDarkButtonColor.toString());
          UserDataManager().lightButtonColorSave(
              userAppStatusModel.button!.appLightButtonColor.toString());
          UserDataManager().transferButtonColorSave(
              userAppStatusModel.button!.transferButtonColor.toString());
          UserDataManager().depositButtonColorSave(
              userAppStatusModel.button!.depositButtonColor.toString());
        }
      }
    }
  }

  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      ConnectivityManager.isNetworkAvailable = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      ConnectivityManager.isNetworkAvailable = true;
    } else {
      ConnectivityManager.isNetworkAvailable = false;
    }
  }
}
