import 'package:gptbanqbusiness/Models/profile_info.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Screens/Profile_screen/bloc/profilee_respo.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../Models/profile/chnage_password_model.dart';
import '../../../Models/profile/logout_model.dart';
import '../../../Models/profile/pay_with_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.init()) {
    on<ProfileEvent>(mapEventToState);
  }

  final ProfileRespo _profileRespo = ProfileRespo();

  void mapEventToState(ProfileEvent event, Emitter<ProfileState> emit) async {
    if (event is getprofileEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          ProfileModel binficaryModel = await _profileRespo.getprofiledata();

          emit(state.update(isloading: false, profileModel: binficaryModel));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
      }
    } else if (event is LogoutEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic logoutModel = await _profileRespo.logout();

          emit(state.update(isloading: false, logoutModel: logoutModel));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
      }
    } else if (event is ChangePasswordEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _profileRespo.changePassword(
              oldPassword: event.oldPassword,
              newPassword: event.newPassword,
              confirmPassword: event.confirmPassword);

          emit(state.update(isloading: false, changePasswordModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
      }
    }  else if (event is ChangePasswordOtpEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _profileRespo.changePasswordOtp(
              requestId: event.requestId,
              otp: event.otp,
              );

          emit(state.update(isloading: false, statusModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
      }
    } else if (event is PayWithEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _profileRespo.payWith(
            payWith: event.payWith,
          );

          emit(state.update(isloading: false, payWithModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isloading: false));
      }
    }
  }
}
