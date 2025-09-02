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
import 'package:gptbanqbusiness/Models/update_doc/update_doc_check_model.dart';
import 'package:gptbanqbusiness/Models/user_get_pin_model.dart';
import 'package:gptbanqbusiness/Screens/Sign_up_screens/bloc/Signup_respotary.dart';
import 'package:gptbanqbusiness/Screens/update_doc_section/bloc/update_doc_repo.dart';
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

part 'update_doc_event.dart';

part 'update_doc_state.dart';

class UpdateDocBloc extends Bloc<UpdateDocEvent, UpdateDocState> {
  UpdateDocBloc() : super(UpdateDocState.init()) {
    on<UpdateDocEvent>(mapEventToState);
  }

  final UpdateDocRepo _updateDocRepo = UpdateDocRepo();

  void mapEventToState(
      UpdateDocEvent event, Emitter<UpdateDocState> emit) async {
    if (event is KycGetUserStatusEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _updateDocRepo.getKycUserStatus();

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
          dynamic response = await _updateDocRepo.getKycDocumentType();

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
          dynamic response = await _updateDocRepo.kycIdVerify(
              uniqueId: event.uniqueId, docTypeStatus: event.docTypeStatus);

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
          dynamic response = await _updateDocRepo.kycAddressVerify(
              uniqueId: event.uniqueId, docTypeStatus: event.docTypeStatus);

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
          dynamic response =
              await _updateDocRepo.kycGetUserImage(uniqueId: event.uniqueId);

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
          dynamic response = await _updateDocRepo.kycFaceVerify(
              image: event.image,
              uniqueId: event.uniqueId,
              docTypeStatus: event.docTypeStatus);

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
          dynamic response = await _updateDocRepo.kycSubmit();

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
          dynamic response = await _updateDocRepo.kycSubmitIsWallet();

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
          dynamic response = await _updateDocRepo.kycStatusCheck();

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
          dynamic response = await _updateDocRepo.kycCreate();

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
          dynamic response = await _updateDocRepo.userKycStatusCheck();

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
    } else if (event is UpdateDocCheckStatusEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _updateDocRepo.updateDocCheckStatus();

          emit(state.update(isloading: false, updateDocCheckModel: response));
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
