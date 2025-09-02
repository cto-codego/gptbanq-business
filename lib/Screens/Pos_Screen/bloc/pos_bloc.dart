import 'package:gptbanqbusiness/Models/pos/check_pos_module_model.dart';
import 'package:gptbanqbusiness/Models/pos/coin_list_model.dart';
import 'package:gptbanqbusiness/Models/pos/create_qr_model.dart';
import 'package:gptbanqbusiness/Models/pos/crypto_gateway_currency_list_model.dart';
import 'package:gptbanqbusiness/Models/pos/crypto_order_cancel_model.dart';
import 'package:gptbanqbusiness/Models/pos/crypto_pos_list_model.dart';
import 'package:gptbanqbusiness/Models/pos/get_crypto_transaction_info_model.dart';
import 'package:gptbanqbusiness/Models/pos_status_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/terminal_models.dart';
import 'package:gptbanqbusiness/Models/terminal_trx_model.dart';
import 'package:gptbanqbusiness/Models/trx_model.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_respotary.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Models/pos/remote_payment_model.dart';
import '../../../Models/pos/store_transaction_log_model.dart';
import '../../../Models/posfees_model.dart';

part 'pos_event.dart';

part '../pos_state.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  PosBloc() : super(PosState.init()) {
    PosRespo _posrespo = new PosRespo();
    on<PosEvent>((event, emit) async {
      if (event is checkposEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            PosstatusModel posstatusModel = await _posrespo.checkpos();

            emit(
                state.update(isloading: false, posstatusModel: posstatusModel));
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
      } else if (event is RequestposEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            StatusModel posstatusModel = await _posrespo.Requestpos();

            emit(state.update(isloading: false, statusModel: posstatusModel));
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
      } else if (event is GetterminalEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            TerminalDevicesmodel posstatusModel =
                await _posrespo.terminadevices();

            emit(state.update(
                isloading: false, terminalDevicesmodel: posstatusModel));
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
      } else if (event is GettransactionsEvent) {
        emit(state.update(
            isloading: true, trxmodel: Trxmodel(trx: [], totalAmount: '')));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            Trxmodel posstatusModel = await _posrespo.gettransactions(
                date: event.date, page: event.page, tid: event.trid);

            emit(state.update(isloading: false, trxmodel: posstatusModel));
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
      } else if (event is GettrxlogEvent) {
        emit(state.update(
            isloading: true,
            trxlogmodel: Trxlogmodel(
                trx: [],
                totalCommission: '',
                totalPending: '0',
                totalCredit: '',
                totalTransacted: '')));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            Trxlogmodel posstatusModel = await _posrespo.getlog(
                date: event.date,
                page: event.page,
                tid: event.trid,
                status: event.status);

            emit(state.update(isloading: false, trxlogmodel: posstatusModel));
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
      } else if (event is posplanEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            PosFeesModel posstatusModel = await _posrespo.posplan();

            emit(state.update(isloading: false, posFeesModel: posstatusModel));
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
      } else if (event is CheckPosModuleEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.checkPosModule();

            if (response is StatusModel) {
              emit(state.update(isloading: false, statusModel: response));
            } else {
              emit(state.update(
                  isloading: false, checkPosModuleModel: response));
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
      } else if (event is CryptoPosListEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.cryptoPosList();

            emit(state.update(isloading: false, cryptoPosListModel: response));
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
      } else if (event is CreateCryptoStoreEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.createCryptoStore(
                label: event.label, currency: event.currency);

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
      } else if (event is CoinListEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.coinList();

            emit(state.update(isloading: false, coinListModel: response));
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
      } else if (event is CreateQrEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.createQr(
              symbol: event.symbol,
              storeId: event.storeId,
              amount: event.amount,
              type: event.type,
              email: event.email,
            );

            if (response is StatusModel) {
              emit(state.update(isloading: false, statusModel: response));
            } else {
              emit(state.update(isloading: false, createQrModel: response));
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
      } else if (event is GetCryptoTransactionInfoEvent) {
        emit(state.update(isloading: false));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.getCryptoTransactionInfo(
                uniqueId: event.uniqueId);

            if (response is StatusModel) {
              emit(state.update(isloading: false, statusModel: response));
            } else {
              emit(state.update(
                  isloading: false, getCryptoTransactionInfoModel: response));
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
      } else if (event is CryptoOrderCancelEvent) {
        emit(state.update(isloading: false));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response =
                await _posrespo.cryptoOrderCancel(uniqueId: event.uniqueId);

            if (response is StatusModel) {
              emit(state.update(isloading: false, statusModel: response));
            } else {
              emit(state.update(
                  isloading: false, cryptoOrderCancelModel: response));
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
      } else if (event is StoreTransactionLogEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response =
                await _posrespo.storeTransactionLogs(storeId: event.storeId);

            if (response is StatusModel) {
              emit(state.update(isloading: false, statusModel: response));
            } else {
              emit(state.update(
                  isloading: false, storeTransactionLogModel: response));
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
      } else if (event is TransactionDetailsEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response =
                await _posrespo.transactionDetails(uniqueId: event.uniqueId);

            if (response is StatusModel) {
              emit(state.update(isloading: false, statusModel: response));
            } else {
              emit(state.update(
                  isloading: false, storeTransactionLogModel: response));
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
      } else if (event is RemotePaymentEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.remotePayment(
                reason: event.reason,
                amount: event.amount,
                storeId: event.storeId,
                type: 'remote',
                email: event.email);

            if (response is StatusModel) {
              emit(state.update(isloading: false, statusModel: response));
            } else {
              emit(
                  state.update(isloading: false, remotePaymentModel: response));
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
      } else if (event is CryptoGatewayCurrencyListEvent) {
        emit(state.update(isloading: true));

        try {
          if (ConnectivityManager.isNetworkAvailable) {
            dynamic response = await _posrespo.cryptoGatewayCurrencyList();

            emit(state.update(
                isloading: false, cryptoGatewayCurrencyListModel: response));
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
    });
  }
}
