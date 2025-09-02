import 'package:gptbanqbusiness/Models/Plans_model.dart';
import 'package:gptbanqbusiness/Models/Set_pin_model.dart';
import 'package:gptbanqbusiness/Models/curruncy_model.dart';
import 'package:gptbanqbusiness/Models/income_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_get_user_image_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_id_verify_model.dart';
import 'package:gptbanqbusiness/Models/kyc/kyc_status_model.dart';
import 'package:gptbanqbusiness/Models/login_response.dart';
import 'package:gptbanqbusiness/Models/login_section/forgot_password_model.dart';
import 'package:gptbanqbusiness/Models/login_section/forgot_password_otp_model.dart';
import 'package:gptbanqbusiness/Models/planLinkModel.dart';
import 'package:gptbanqbusiness/Models/signup_response_model.dart';
import 'package:gptbanqbusiness/Models/sourceoffund.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/user_get_pin_model.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/Signup_respotary.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../Models/kyc/get_kyc_user_status_model.dart';
import '../../../Models/kyc/kyc_address_verify_model.dart';
import '../../../Models/kyc/kyc_create_model.dart';
import '../../../Models/kyc/kyc_document_type_model.dart';
import '../../../Models/kyc/kyc_face_verify_model.dart';
import '../../../Models/kyc/kyc_submit_model.dart';
import '../../../Models/kyc/user_kyc_check_status_model.dart';
import '../../../Models/login_section/login_email_verified_model.dart';
import '../../../Models/signup_models/signup_email_verified_model.dart';
import '../../../Models/signup_models/user_signup_account_model.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState.init()) {
    on<SignupEvent>(mapEventToState);
  }

  final SignupRespo _signupRespo = SignupRespo();

  void mapEventToState(SignupEvent event, Emitter<SignupState> emit) async {
    if (event is sendemailotpEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel =
              await _signupRespo.Sendemaiotp(email: event.email);

          emit(state.update(isloading: false, statusModel: statusModel));
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
    } else if (event is SignupPersonalDataEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          SignUpResponseModel signUpResponseModel =
              await _signupRespo.signupdata();

          // ignore: unused_local_variable
          StatusModel statusModel;
          if (signUpResponseModel.status == 1) {
            UserDataManager().saveUserId(signUpResponseModel.userId!);

            // ignore: unused_local_variable
            StatusModel statusModel = await _signupRespo.Sendkyc();
          }

          emit(state.update(
              isloading: false, signUpResponseModel: signUpResponseModel));
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
    } else if (event is SourcefundEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          SourceFund sourceFund = await _signupRespo.getsourcefund();

          emit(state.update(isloading: false, sourceFund: sourceFund));
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
    } else if (event is UpdatesourceEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel sourceFund = await _signupRespo.uploadsourceoffund(
              image: event.photo,
              occupation: event.occupation,
              source: event.source,
              signature: event.signature);

          emit(state.update(isloading: false, statusModel: sourceFund));
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
    } else if (event is incomesourceEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          IncomeModel incomeModel = await _signupRespo.incomesourcefun();

          emit(state.update(isloading: false, incomeModel: incomeModel));
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
    } else if (event is otpVerifyEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.otpVerification(
              otp: event.otp, email: event.email, deviceType: event.deviceType);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false, signupEmailVerifiedModel: response));
          }
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
    } else if (event is resendotpVerifyEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          // StatusModel statusModel = await _signupRespo.ResendtpVerification();

          emit(state.update(
            isloading: false,
          ));
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
    } else if (event is getCurruncyEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          CurrunciesModel currunciesModel = await _signupRespo.getcurruncies();

          emit(
              state.update(isloading: false, currunciesModel: currunciesModel));
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
    } else if (event is addProfileEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await _signupRespo.uploadProfilePicture(
              fileProfilePicturePath: event.photo);

          emit(state.update(isloading: false, statusModel: statusModel));
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
    } else if (event is SendkyclinkEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await _signupRespo.Sendkyc();

          if (statusModel.status == 1) {
            User.resendkyc = false;
          }

          emit(state.update(isloading: false, statusModel: statusModel));
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
    } else if (event is GetplanlistEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          PlansModel plansModel = await _signupRespo.Getplanlist();

          emit(state.update(isloading: false, plansModel: plansModel));
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
    } else if (event is PlanLinkEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Planlinkmodel plansModel = await _signupRespo.getplanlink();

          emit(state.update(isloading: false, planlinkmodel: plansModel));
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
    } else if (event is uploadproffadressEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await _signupRespo.uploadKycproffAdreess(
              passportpic: event.front);

          emit(state.update(isloading: false, statusModel: statusModel));
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
    } else if (event is UpgradeplanEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel =
              await _signupRespo.upgradeplan(unquid: event.uniqueid);

          emit(state.update(isloading: false, statusModel: statusModel));
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
    } else if (event is setPinEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          SetUserPinResponseModel setpinModel =
              await _signupRespo.Setpin(pincode: event.pin);

          if (setpinModel.status == 1) {
            debugPrint("setUserPinResponseModel.token new");
            debugPrint("${setpinModel.token}");
            UserDataManager().saveToken(setpinModel.token!);
            UserDataManager().savePin(event.pin);
          }

          emit(state.update(isloading: false, setpinModel: setpinModel));
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
    } else if (event is GetUserPinEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          UserGetPinModel userGetPinModel = await _signupRespo.getNewPin(
              event.userpin, event.version, event.seonData);

          if (userGetPinModel.status == 1) {
            debugPrint("getUserPinEvent.token: ");
            debugPrint(userGetPinModel.token);
            UserDataManager().saveToken(userGetPinModel.token!);
          }
          emit(state.update(
            isloading: false,
            userGetPinModel: userGetPinModel,
          ));
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
    } else if (event is UserSignupEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.userSignupAccountRequest(
              name: event.name,
              surname: event.surname,
              email: event.email,
              deviceType: event.devictype,
              password: event.password,
              seonSession: event.seonSession);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false, userSignupAccountModel: response));
          }
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
    } else if (event is siginInEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.loginRequest(
              email: event.email,
              deviceType: event.devictype,
              password: event.password,
              seOnSession: event.seonSession);

          emit(state.update(isloading: false, loginResponse: response));
          if (response is LoginResponse) {
            UserDataManager().saveUserId(response.userId!);
            UserDataManager().saveToken(response.token!);
          }
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
    } else if (event is LoginRequestVerifyEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.loginRequestVerify(
            token: event.token,
            verificationCode: event.verificationCode,
            userId: event.userId,
          );

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            UserDataManager().saveUserId(event.userId);
            UserDataManager().saveToken(event.token);
            emit(state.update(
              isloading: false,
              loginEmailVerifiedModel: response,
            ));
          }
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is LoginBioStatusEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.loginBioStatus(
            status: event.status,
            userId: event.userId,
          );

          emit(state.update(isloading: false, statusModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycGetUserStatusEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.getKycUserStatus();

          emit(state.update(isloading: false, getKycUserStatusModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycDocumentTypeEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.getKycDocumentType();

          emit(state.update(isloading: false, kycDocumentTypeModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycIdVerifyEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.kycIdVerify();

          emit(state.update(isloading: false, kycIdVerifyModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycAddressVerifyEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.kycAddressVerify();

          emit(state.update(isloading: false, kycAddressVerifyModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycGetUserImageEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.kycGetUserImage();

          emit(state.update(isloading: false, kycGetUserImageModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycFaceVerifyEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await _signupRespo.kycFaceVerify(image: event.image);

          emit(state.update(isloading: false, kycFaceVerifyModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycSubmitEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.kycSubmit();

          emit(state.update(isloading: false, kycSubmitModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycSubmitIsWalletEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.kycSubmitIsWallet();

          emit(state.update(isloading: false, kycSubmitModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycStatusCheckEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.kycStatusCheck();

          emit(state.update(isloading: false, kycStatusModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is KycCreateEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.kycCreate();

          emit(state.update(isloading: false, kycCreateModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is UserKycCheckStatusEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.userKycStatusCheck();

          if (response is UserKycCheckStatusModel) {
            UserDataManager().statusMessageSave(response.message.toString());
          }
          emit(state.update(
              isloading: false, userKycCheckStatusModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is ForgotPasswordEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await _signupRespo.forgotPassword(email: event.email);

          if (response is ForgotPasswordModel) {
            UserDataManager().statusMessageSave(response.message.toString());
            UserDataManager()
                .forgotPassUniqueIdSave(response.uniqueId.toString());
            UserDataManager().forgotPassUserIdSave(response.userId.toString());
          }

          emit(state.update(isloading: false, forgotPasswordModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is ForgotPasswordOtpEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.forgotPasswordOtp(
              uniqueId: event.uniqueId,
              userId: event.userId,
              code: event.code,
              seonData: event.seonData);

          if (response is ForgotPasswordOtpModel) {
            UserDataManager().statusMessageSave(response.message.toString());
          }

          emit(
              state.update(isloading: false, forgotPasswordOtpModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is ForgotPasswordBiometricEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.forgotPasswordBiometric(
              userId: event.userId, status: event.status);

          if (response is StatusModel) {
            UserDataManager().statusMessageSave(response.message.toString());
          }

          emit(state.update(isloading: false, statusModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is ResetPasswordEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _signupRespo.resetPassword(
              userId: event.userId,
              password: event.password,
              confirmPassword: event.confirmPassword);

          if (response is StatusModel) {
            UserDataManager().statusMessageSave(response.message.toString());
          }

          emit(state.update(isloading: false, statusModel: response));
        } else {
          emit(state.update(isloading: false));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    }
  }
}
