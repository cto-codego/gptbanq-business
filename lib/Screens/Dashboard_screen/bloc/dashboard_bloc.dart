import 'package:gptbanqbusiness/Models/Card_details_model.dart';
import 'package:gptbanqbusiness/Models/Dashboard_model.dart';
import 'package:gptbanqbusiness/Models/beneficiary/swift_add_beneficiary_model.dart';
import 'package:gptbanqbusiness/Models/card_ordermodel.dart';
import 'package:gptbanqbusiness/Models/dashboard/deposit_dashboard_model.dart';
import 'package:gptbanqbusiness/Models/dashboard/swift_deposit_model.dart';
import 'package:gptbanqbusiness/Models/debit_card_model.dart';
import 'package:gptbanqbusiness/Models/debitcardinfo_model.dart';
import 'package:gptbanqbusiness/Models/gift_card/buy_gift_card_confirm_model.dart';
import 'package:gptbanqbusiness/Models/gift_card/gift_card_get_fee_type_model.dart';
import 'package:gptbanqbusiness/Models/pdf_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/transactiondetailsModel.dart';
import 'package:gptbanqbusiness/Models/update_model.dart';
import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_respotary.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../Models/card/add_card_beneficiary_model.dart';
import '../../../Models/card/card_active_model.dart';
import '../../../Models/card/card_beneficiary_list_model.dart';
import '../../../Models/card/card_block_unblock_model.dart';
import '../../../Models/card/card_details_model.dart';
import '../../../Models/card/card_iban_get_custom_account_model.dart';
import '../../../Models/card/card_iban_list_model.dart';
import '../../../Models/card/card_list_model.dart';
import '../../../Models/card/card_order_confirm_model.dart';
import '../../../Models/card/card_order_details_model.dart';
import '../../../Models/card/card_order_type_model.dart';
import '../../../Models/card/card_replace_model.dart';
import '../../../Models/card/card_settings_model.dart';
import '../../../Models/card/card_to_card_transfer_confirm_model.dart';
import '../../../Models/card/card_to_card_transfer_fee_model.dart';
import '../../../Models/card/card_topup_confirm_model.dart';
import '../../../Models/card/card_topup_fee_model.dart';
import '../../../Models/card/card_type_model.dart';
import '../../../Models/card/delete_card_beneficiary_model.dart';
import '../../../Models/convert/convert_currency_list_model.dart';
import '../../../Models/dashboard/iban_currency_model.dart';
import '../../../Models/dashboard/iban_kyc_check_model.dart';
import '../../../Models/dashboard/create_iban_list_model.dart';
import '../../../Models/dashboard/no_response_model.dart';
import '../../../Models/dashboard/terms_pdf_model.dart';
import '../../../Models/dashboard/transaction_list_model.dart';
import '../../../Models/download_transaction_model.dart';
import '../../../Models/gift_card/gift_card_delete_model.dart';
import '../../../Models/gift_card/gift_card_details_model.dart';
import '../../../Models/gift_card/gift_card_get_fee_data_model.dart';
import '../../../Models/gift_card/gift_card_list_model.dart';
import '../../../Models/gift_card/gift_card_share_model.dart';
import '../../../Models/iban_list/iban_list.dart';
import '../../../Models/transaction_approved_model.dart';
import '../../../Models/trx_biometric_confirmation_notifications_model.dart';
import '../../../Models/wallet_transfer/wallet_transfer_iban_list_model.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState.init()) {
    on<DashboardEvent>(mapEventToState);
  }

  final DashboardRespotary _dashboardRespotary = DashboardRespotary();

  void mapEventToState(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    if (event is DashboarddataEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          DashboardModel dashboardModel =
          await _dashboardRespotary.getdashboard();

          emit(state.update(
            isloading: false,
            dashboardModel: dashboardModel,
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
    } else if (event is ShareibanEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel dashboardModel = await _dashboardRespotary.Sendemail(
              email: event.email, iban: event.iban);

          emit(state.update(
            isloading: false,
            statusModel: dashboardModel,
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
    } else if (event is closenotificationEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          // StatusModel dashboardModel =
          //     await _dashboardRespotary.closenotify(id: event.notifId);

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
    } else if (event is OrdercardEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          DebitFees debitFees =
          await _dashboardRespotary.ordercard(type: event.type);

          emit(state.update(isloading: false, debitFees: debitFees));
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
    } else if (event is confirmdebitorder) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitFees = await _dashboardRespotary.deitCardOrder();

          emit(state.update(isloading: false, statusModel: debitFees));
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
    } else if (event is ApproveBrowserLoginEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitFees = await _dashboardRespotary.approveBrowserLogin(
              loginStatus: event.loginStatus, uniqueId: event.uniqueId);

          emit(state.update(isloading: false, statusModel: debitFees));
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
    // else if (event is checkupdate) {
    //   emit(state.update(isloading: false));
    //
    //   try {
    //     if (ConnectivityManager.isNetworkAvailable) {
    //       UpdateModel debitFees = await _dashboardRespotary.checkupdatefun();
    //
    //       emit(state.update(isloading: false, updateModel: debitFees));
    //     } else {
    //       emit(state.update(isloading: false));
    //     }
    //   } on ApiException catch (e) {
    //     debugPrint(e.toString());
    //     emit(state.update(isloading: false));
    //     // ignore: use_rethrow_when_possible
    //     throw (e);
    //   } catch (e) {
    //     debugPrint(e.toString());
    //     emit(state.update(isloading: false));
    //   }
    // }
    else if (event is debitcardfees) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          DebitFees debitFees =
          await _dashboardRespotary.debitcardfees(type: event.type);

          emit(state.update(isloading: false, debitFees: debitFees));
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
    } else if (event is ActivateDebutcardEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitFees = await _dashboardRespotary.activatedeitCard(
              cardNumber: event.cardnumber,
              cvv: event.cvv,
              mm: event.mm,
              yy: event.yy);

          emit(state.update(isloading: false, statusModel: debitFees));
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
    } else if (event is activateDebitwithcodeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitFees = await _dashboardRespotary.debitCardactivate(
              activate: event.code, cardnumber: event.lastdigit);

          emit(state.update(isloading: false, statusModel: debitFees));
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
    } else if (event is DebitcarddetailsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          CardDetails cardDetails =
          await _dashboardRespotary.DebitCarddetails();

          emit(state.update(isloading: false, cardDetails: cardDetails));
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
    } else if (event is ApproveTransactionEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.approveTransaction(
              completed: event.completed, uniqueId: event.uniqueId);

          emit(state.update(isloading: false, transactionApprovedModel: data));
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
    } else if (event is ApproveEurotoIbanEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await _dashboardRespotary.approveEurotoiban(
              completed: event.completed, uniqueId: event.uniqueId);

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
    } else if (event is ApproveEurotoCryptoEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel =
          await _dashboardRespotary.approveEurotocrypto(
              completed: event.completed, uniqueId: event.uniqueId);

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
    } else if (event is transactiondetailsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Transactiondetailsmodel cardDetails =
          await _dashboardRespotary.transactiondetails(id: event.uniqueId);

          emit(state.update(
              isloading: false, transactiondetailsmodel: cardDetails));
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
    } else if (event is DawnloadEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Pdfmodel statusModel =
          await _dashboardRespotary.Dawnloadinvoice(id: event.uniqueId);

          emit(state.update(isloading: false, pdfmodel: statusModel));
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
    } else if (event is debitcardinfoevent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Debitcardinfo debitcardinfo = await _dashboardRespotary
              .debitcardinform(cardId: event.cardid, pin: event.pin);

          emit(state.update(isloading: false, debitcardinfo: debitcardinfo));
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
    } else if (event is ResetCardPinEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitcardinfo = await _dashboardRespotary.resetCardPin(
              cardId: event.cardId, cardPin: event.cardPin);

          emit(state.update(isloading: false, statusModel: debitcardinfo));
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
    } else if (event is UpdateCardSettingEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitcardinfo =
          await _dashboardRespotary.updateCardSetting(
              cardId: event.cardId,
              settingName: event.settingName,
              settingValue: event.settingValue);

          emit(state.update(isloading: false, statusModel: debitcardinfo));
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
    } else if (event is ApproveMoveWalletsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitcardinfo =
          await _dashboardRespotary.approvmovewalletsfun(
              completed: event.completed, uniqueId: event.uniqueId);

          emit(state.update(isloading: false, statusModel: debitcardinfo));
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
    } else if (event is checkcardEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Cardordermodel debitcardinfo = await _dashboardRespotary.checkcard();

          emit(state.update(isloading: false, cardordermodel: debitcardinfo));
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
    } else if (event is Movebalancetodebit) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitcardinfo = await _dashboardRespotary.movebalance(
              amount: event.amount, ibanid: event.ibanid);

          emit(state.update(isloading: false, statusModel: debitcardinfo));
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
    } else if (event is GiftCardListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.giftCardList();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, giftCardListModel: response));
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
    } else if (event is GiftCardGetFeeTypeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.giftCardGetFeeType();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false, giftCardGetFeeTypeModel: response));
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
    } else if (event is GiftCardGetFeeDataEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.giftCardGetFeeData(
              amount: event.amount);

          // Check the type of response
          if (response is StatusModel) {
            // If it's an error, emit error state
            emit(state.update(isloading: false, statusModel: response));
          } else {
            // If it's successful, emit success state
            emit(state.update(
                isloading: false, giftCardGetFeeDataModel: response));
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
    } else if (event is GiftCardGetOrderConfirmEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.giftCardOrderConfirm();

          emit(state.update(
              isloading: false, buyGiftCardConfirmModel: response));
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
    } else if (event is GiftCardGetDetailsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.giftCardDetails();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(
                state.update(isloading: false, giftCardDetailsModel: response));
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
    } else if (event is GiftCardDeleteEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.giftCardDelete();

          // Check the type of response
          emit(state.update(isloading: false, giftCardDeleteModel: response));
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
    } else if (event is GiftCardShareEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.giftCardShare();

          // Check the type of response
          emit(state.update(isloading: false, giftCardShareModel: response));
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
    } else if (event is CardListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardList();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardListModel: response));
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
    } else if (event is CardOrderTypeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardOrderType();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardOrderTypeModel: response));
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
    } else if (event is CardTypeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardType();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardTypeModel: response));
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
    } else if (event is CardFeeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardOrderDetails();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(
                state.update(isloading: false, cardOderDetailsModel: response));
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
    } else if (event is CardOrderConfirmEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
          await _dashboardRespotary.cardOrderConfirm(ibanId: event.ibanId);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false, cardOrderConfirmModel: response));
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
    } else if (event is CardDetailsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardDetails();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(
                state.update(isloading: false, userCardDetailsModel: response));
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
    } else if (event is CardActiveEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardActive();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardActiveModel: response));
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
    } else if (event is CardSettingsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardSettings();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardSettingsModel: response));
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
    } else if (event is CardBlockUnblockEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardBlockUnblock();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false, cardBlockUnblockModel: response));
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
    } else if (event is CardReplaceEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardReplace();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardReplaceModel: response));
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
    } else if (event is CardIbanListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardIbanList();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardIbanListModel: response));
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
    } else if (event is CardTopupAmountEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
          await _dashboardRespotary.cardTopupFee(ibanId: event.ibanId);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, cardTopUpFeeModel: response));
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
    } else if (event is CardTopupConfirmEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.cardTopupConfirm(ibanId: event.ibanId);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false, cardTopUpConfirmModel: response));
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
    } else if (event is TrxBiometricDetailsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary
              .trxBiometricConfirmationDetails(uniqueId: event.uniqueId);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false,
                trxBiometricConfirmationNotificationsModel: response));
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
    } else if (event is TrxBiometricConfirmOrCancelEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.trxBiometricConfirmOrCancel(
              loginStatus: event.loginStatus, uniqueId: event.uniqueId);

          emit(state.update(isloading: false, transactionApprovedModel: data));
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
    } else if (event is CardBeneficiaryListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.getCardBeneficiaryList();

          emit(state.update(isloading: false, cardBeneficiaryListModel: data));
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
    } else if (event is AddCardBeneficiaryEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.addCardBeneficiary();

          emit(state.update(isloading: false, statusModel: data));
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
    } else if (event is DeleteCardBeneficiaryEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.deleteCardBeneficiary();

          emit(
              state.update(isloading: false, deleteCardBeneficiaryModel: data));
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
    } else if (event is CardToCardTransferFeesEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.cardToCardTransferFees();

          emit(
              state.update(isloading: false, cardToCardTransferFeeModel: data));
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
    } else if (event is CardToCardTransferConfirmEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.cardToCardTransferConfirm();

          emit(state.update(isloading: false, statusModel: data));
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
    } else if (event is DownloadTransactionStatementEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data =
          await _dashboardRespotary.downloadTransactionStatement();

          emit(state.update(isloading: false, transactionListModel: data));
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
          IbanlistModel ibanlistModel = await _dashboardRespotary.ibanlist();

          emit(state.update(
            isloading: false,
            ibanlistModel: ibanlistModel,
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
    } else if (event is CreateibanEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel dashboardModel = await _dashboardRespotary.Createiban(
              label: event.Label,
              currency: event.currency,
              iban: event.iban,
              isWallet: event.isWallet);

          emit(state.update(
            isloading: false,
            statusModel: dashboardModel,
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
    } else if (event is GetIbanCurrencyEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.getIbanCurrency();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, ibanCurrencyModel: response));
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
    } else if (event is getMultipleIbanEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
          await _dashboardRespotary.getIbanList(currency: event.currency!);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, createIbanListModel: response));
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
    } else if (event is IbanSumSubVerified) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.getibanSumSubVerified(
              currency: event.currency!, iban: event.iban!);

          emit(state.update(isloading: false, ibanKycCheckModel: response));
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
    } else if (event is DynamicBeneficiaryCurrencyEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.swiftCountryList();

          emit(state.update(
              isloading: false, swiftAddBeneficiaryModel: response));
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
    } else if (event is SwiftDepositEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.swiftDepositData();

          emit(state.update(isloading: false, swiftDepositModel: response));
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
    } else if (event is SwiftTermsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.swiftTermsData(
              type: event.type!, deviceType: event.deviceType!);

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
    } else if (event is DepositAccountDetailsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await _dashboardRespotary.depositAccountDetails(
            ibanId: event.ibanId!,
          );

          emit(state.update(isloading: false, depositDashboardModel: response));
        } else {
          emit(state.update(
            isloading: false,
          ));
        }
      } on ApiException catch (e) {
        print(e);
        emit(state.update(isloading: false));
        throw (e);
      } catch (e) {
        print(e);
        emit(state.update(isloading: false));
      }
    } else if (event is ConvertCurrencyListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.getConvertCurrencyList(
              buyCurrency: event.buyCurrency!);

          emit(state.update(isloading: false, convertCurrencyListModel: data));
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
    } else if (event is TermsPdfEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _dashboardRespotary.termsPdf();

          emit(state.update(isloading: false, termsPdfModel: data));
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
    } else if (event is CardIbanCallEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
          await _dashboardRespotary.cardIbanGetCustomAccountDetails();

          emit(state.update(
              isloading: false, cardIbanGetCustomAccountsModel: response));
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
    } else if (event is CardTopUpIbanCallEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
          await _dashboardRespotary.cardTopUpIbanGetCustomAccountDetails();

          emit(state.update(
              isloading: false, cardIbanGetCustomAccountsModel: response));
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
    } else if (event is WalletTransferIbanListEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic walletTransferIbanListData = await _dashboardRespotary
              .walletTransferIbanList(ibanId: event.ibanId);

          emit(state.update(
              isloading: false,
              walletTransferIbanListModel: walletTransferIbanListData));
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
    } else if (event is RequestForSessionDataEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic dataModel = await _dashboardRespotary
              .requestForSessionDataApi(uniqueId: event.uniqueId);

          emit(state.update(
            isloading: false,
            noResponseModel: dataModel,
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
    }

    if (event is opendialog) {
      if (event.open == false) {
        debugPrint("object");

        emit(state.update(
          isloading: false,
          open: true,
        ));
      }
    }
  }
}

