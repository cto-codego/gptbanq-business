import 'package:gptbanqbusiness/Models/Regula_model.dart';
import 'package:gptbanqbusiness/Models/Sendmone_model.dart';
import 'package:gptbanqbusiness/Models/Sepa_models.dart';
import 'package:gptbanqbusiness/Models/beneficiary/swift_send_money_user_model.dart';
import 'package:gptbanqbusiness/Models/beneficiary_countries.dart';
import 'package:gptbanqbusiness/Models/binficary_model.dart';
import 'package:gptbanqbusiness/Models/push_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_respotary.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../Models/beneficiary/dynamic_add_beneficiary_model.dart';
import '../../../Models/beneficiary/dynamic_beneficiary_field_model.dart';
import '../../../Models/beneficiary/swift_add_beneficiary_model.dart';
import '../../../Models/iban_list/iban_list.dart';
import '../../../Models/send_money/swift_payment_model.dart';

part 'transfer_event.dart';

part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc() : super(TransferState.init()) {
    on<TransferEvent>(mapEventToState);
  }

  void mapEventToState(TransferEvent event, Emitter<TransferState> emit) async {
    TransferRespo transferRespo = TransferRespo();

    if (event is binficarylistEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          BinficaryModel binficaryModel =
              await transferRespo.getbinficiarylist(ibanId: event.ibanId);

          emit(state.update(isloading: false, binficaryModel: binficaryModel));
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
    } else if (event is AddExternalbenficaryEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await transferRespo.addbinfechary(
            name: event.firstname,
            type: event.type,
            iban: event.iban,
            email: event.email,
            image: event.image,
            bic: event.bic,
            companyname: event.companyname,
            lastname: event.lastname,
          );

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
    } else if (event is ApproveibanTransactionEvent) {
      emit(state.update(
        isloading: true,
        statusModel: StatusModel(status: 22, message: ''),
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          PushModel pushModel = await transferRespo.approveibanTransaction(
              completed: event.completed,
              lat: event.lat,
              long: event.long,
              uniqueId: event.uniqueId);

          debugPrint("ApproveBrowserLoginEvent");
          emit(state.update(
            isloading: false,
            pushModel: pushModel,
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
    } else if (event is ApproveibanSwiftTransactionEvent) {
      emit(state.update(
        isloading: true,
        statusModel: StatusModel(status: 22, message: ''),
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          PushModel pushModel = await transferRespo.approveIbanSwiftTransaction(
              completed: event.completed,
              lat: event.lat,
              long: event.long,
              uniqueId: event.uniqueId);

          debugPrint("ApproveBrowserLoginEvent");
          emit(state.update(
            isloading: false,
            pushModel: pushModel,
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
    } else if (event is RegulaupdateBiometric) {
      emit(state.update(
        isloading: true,
        statusModel: StatusModel(status: 22, message: ''),
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          RegulaModel regulaModel = await transferRespo.updateregula(
              kycid: event.kycid,
              match: event.facematch,
              userimage: event.userimage);

          debugPrint("ApproveBrowserLoginEvent");
          emit(state.update(
            isloading: false,
            regulaModel: regulaModel,
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
    } else if (event is SepatypesEvent) {
      emit(state.update(
        isloading: true,
        statusModel: StatusModel(status: 22, message: ''),
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Sepatypesmodel statusModel = await transferRespo.sepatypes();

          debugPrint("ApproveBrowserLoginEvent");
          emit(state.update(
            isloading: false,
            sepatypesmodel: statusModel,
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
    } else if (event is DeleteBeneficiaryEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel =
              await transferRespo.deleteBeneficiary(uniqueId: event.uniqueId);

          emit(state.update(
            isloading: false,
            statusModel: statusModel,
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
    } else if (event is SendmoneyEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          SendmoneyModel statusModel = await transferRespo.Sendmoneyfun(
              amount: event.amount,
              beneficiary: event.uniquid,
              reference: event.refrence,
              ibanid: event.iban,
              paymentoption: event.paymentoption);

          emit(state.update(isloading: false, sendmoneyModel: statusModel));
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
    } else if (event is SwiftSendmoneyEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await transferRespo.swiftSendMoneyFun(
            amount: event.amount,
            beneficiary: event.uniquid,
            reference: event.refrence,
            ibanid: event.iban,
            paymentoption: event.paymentoption,
            seOnSession: event.seOnSession,
            sendNotification: event.sendNotification,
            swiftShared: event.swiftShared,
            paymentCode: event.paymentCode,
          );

          emit(state.update(isloading: false, swiftPaymentModel: data));
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
    } else if (event is AddExternalbenficaryEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await transferRespo.addbinfechary(
            name: event.firstname,
            type: event.type,
            iban: event.iban,
            email: event.email,
            image: event.image,
            bic: event.bic,
            companyname: event.companyname,
            lastname: event.lastname,
          );

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
    } else if (event is SwipconfirmEvent) {
      emit(state.update(
        isloading: true,
      ));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel =
              await transferRespo.Swipconfirm(id: event.unique_id);

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
    } else if (event is getibanlistEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          IbanlistModel dashboardModel =
              await transferRespo.ibanlist(beneficiaryId: event.beneficiaryId);

          emit(state.update(
            isloading: false,
            ibanlistModel: dashboardModel,
          ));
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
    } else if (event is GetSwiftCountryListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          SwiftAddBeneficiaryModel data =
              await transferRespo.swiftCountryList();

          emit(state.update(
            isloading: false,
            swiftAddBeneficiaryModel: data,
          ));
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
    } else if (event is GetDynamicBeneficiaryFieldListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          DynamicBeneficiaryFieldModel data =
              await transferRespo.dynamicBeneficiaryFieldList(
                  country: event.country,
                  currency: event.currency,
                  accountType: event.accountType);

          emit(state.update(
            isloading: false,
            dynamicBeneficiaryFieldModel: data,
          ));
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
    } else if (event is AddDynamicBeneficiaryEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          DynamicAddBeneficiaryModel data =
              await transferRespo.addDynamicBeneficiary(
            country: event.country!,
            currency: event.currency!,
            accountType: event.accountType!,
            recipientCountry: event.recipientCountry!,
            dynamicData: [event.dynamicFrom],
            image: event.image!,
            beneficiaryIdentificationType: event.beneficiaryIdentificationType!,
            beneficiaryIdentificationValue:
                event.beneficiaryIdentificationValue!,
          );

          emit(state.update(
            isloading: false,
            dynamicAddBeneficiaryModel: data,
          ));
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
    } else if (event is GetSwiftPaymentCodeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await transferRespo.swiftSendMoneyPaymentCode(
            id: event.id,
          );

          emit(state.update(
            isloading: false,
            swiftSendMoneyUserModel: data,
          ));
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
