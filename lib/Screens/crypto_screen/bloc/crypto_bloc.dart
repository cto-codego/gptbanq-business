import 'package:gptbanqbusiness/Models/Coin_qr_model.dart';
import 'package:gptbanqbusiness/Models/Crypto_coins_model.dart';
import 'package:gptbanqbusiness/Models/coin_details_model.dart';
import 'package:gptbanqbusiness/Models/convert_preview_model.dart';
import 'package:gptbanqbusiness/Models/networks_token.dart';
import 'package:gptbanqbusiness/Models/networktype.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Screens/crypto_screen/bloc/respotary.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../Models/crypto/eur_withdraw_model.dart';
import '../../../Models/crypto/iban_deposit_eur_to_crypto_cancel_model.dart';
import '../../../Models/crypto/iban_deposit_eur_to_crypto_model.dart';
import '../../../Models/crypto/new_stake_request_model.dart';
import '../../../Models/crypto/stake_confirm_model.dart';
import '../../../Models/crypto/stake_custom_period_model.dart';
import '../../../Models/crypto/stake_fee_balance_model.dart';
import '../../../Models/crypto/stake_order_model.dart';
import '../../../Models/crypto/stake_overview_model.dart';
import '../../../Models/crypto/stake_period_model.dart';
import '../../../Models/crypto/stake_profit_log.dart';
import '../../../Models/crypto/stake_stop_model.dart';
import '../../../Models/iban_list/iban_list.dart';
import '../../../Models/stake/iban_get_custom_account_model.dart';

part 'crypto_event.dart';

part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  CryptoBloc() : super(CryptoState.init()) {
    on<CryptoEvent>(mapEventToState);
  }

  CryptoRespo cryptoRespo = CryptoRespo();

  void mapEventToState(CryptoEvent event, Emitter<CryptoState> emit) async {
    if (event is GetcoinsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Coins cardDetails = await cryptoRespo.fetchcoins();

          emit(state.update(isloading: false, coins: cardDetails));
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
    } else if (event is RefreshGetcoinsEvent) {
      emit(state.update(isloading: false));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Coins cardDetails = await cryptoRespo.fetchcoins();

          emit(state.update(isloading: false, coins: cardDetails));
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
    } else if (event is GetcoinDetailsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          CoindetailsModel cardDetails =
              await cryptoRespo.getcoindetails(symbol: event.symbol);

          emit(state.update(isloading: false, coindetailsModel: cardDetails));
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
    } else if (event is UpdateGetcoinDetailsEvent) {
      emit(state.update(isloading: false));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          CoindetailsModel cardDetails =
              await cryptoRespo.getcoindetails(symbol: event.symbol);

          emit(state.update(isloading: false, coindetailsModel: cardDetails));
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
    } else if (event is GetnetworkEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          SendNetwork sendNetwork =
              await cryptoRespo.networkfun(symbol: event.symbol);

          emit(state.update(isloading: false, sendNetwork: sendNetwork));
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
    } else if (event is GenerateaddressEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          CoinQrcode coinQrcode =
              await cryptoRespo.generateaddress(symbol: event.symbol);

          emit(state.update(isloading: false, coinQrcode: coinQrcode));
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
    } else if (event is GenerateQrcodeNetworksEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          Tokennetworks tokennetworks =
              await cryptoRespo.generaNetworkstoken(symbol: event.symbol);

          emit(state.update(isloading: false, tokennetworks: tokennetworks));
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
    } else if (event is ConvercoinEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          ConvertModel convertModel = await cryptoRespo.convertPreview(
              amount: event.amount,
              basesymbol: event.basesymbol,
              from: event.from,
              to: event.to);

          emit(state.update(isloading: false, convertModel: convertModel));
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
    } else if (event is SendCoinEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await cryptoRespo.sendCoin(
            amount: event.amount,
            address: event.address,
            currencyId: event.currencyId,
            network: event.network,
            memo: event.memo,
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
    } else if (event is ConfirmConvertevent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel statusModel = await cryptoRespo.Confirmconvert(
              amount: event.amount,
              base_coin_symbol: event.base_coin_symbol,
              from_symbol: event.from_coin,
              to_symbol: event.to_coin,
              type: event.type);

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
    } else if (event is MovetoIbanEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.Movetoiban(
              amount: event.amount, ibanid: event.ibanid);

          emit(state.update(isloading: false, eurWithdrawModel: response));
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
    } else if (event is MoveEurotocryptoEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.MoveEurotocrypto(
              amount: event.amount, ibanid: event.ibanid);

          emit(state.update(
              isloading: false, ibanDepositEurToCryptoModel: response));
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
          dynamic response = await cryptoRespo.approveEurotocrypto(
              completed: event.completed, uniqueId: event.uniqueId);

          emit(state.update(
              isloading: false, ibanDepositEurToCryptoCancelModel: response));
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
          dynamic response = await cryptoRespo.approveEurotoiban(
              completed: event.completed, uniqueId: event.uniqueId);

          emit(state.update(
              isloading: false, ibanDepositEurToCryptoCancelModel: response));
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
          StatusModel statusModel = await cryptoRespo.approveTransaction(
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
    } else if (event is ApproveMoveWalletsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          StatusModel debitcardinfo = await cryptoRespo.approvmovewalletsfun(
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
    } else if (event is StakeRequestEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.newStakeRequest(
            symbol: event.symbol,
            amount: event.amount,
            period: event.period,
            isCustom: event.isCustom,
            ibanId: event.ibanId,
          );

          emit(state.update(isloading: false, newStakeRequestModel: response));
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
    } else if (event is StakeOverviewEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await cryptoRespo.getStakeOverview(symbol: event.symbol);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, stakeOverviewModel: response));
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
    } else if (event is StakeProfitLogEvent) {
      emit(state.update(isloading: false));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await cryptoRespo.getStakeProfitLog(orderId: event.orderId);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, stakeProfitLog: response));
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
    } else if (event is StakeStopEvent) {
      emit(state.update(isloading: false));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await cryptoRespo.getStakeStop(orderId: event.orderId);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, stakeStopModel: response));
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
    } else if (event is StakeFeeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await cryptoRespo.getStakeFee(symbol: event.symbol);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(
                state.update(isloading: false, stakeFeeBalanceModel: response));
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
    } else if (event is StakeOrderEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.getStakeOrder(
              symbol: event.symbol, amount: event.amount);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, stakeOrderModel: response));
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
    } else if (event is StakeConfirmEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.getStakeOrderConfirm(
            orderId: event.orderId,
          );

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, stakeConfirmModel: response));
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
    } else if (event is getibanlistEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          IbanlistModel dashboardModel = await cryptoRespo.ibanlist();

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
    } else if (event is StakePeriodEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.getStakePeriod();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(
                isloading: false, stakeCustomPeriodModel: response));
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
    } else if (event is SwiftTermsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.swiftTermsData(
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
    } else if (event is IbanGetCustomAccountEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await cryptoRespo.ibanGetCustomAccountDetails(
              type: event.type, symbol: event.symbol);

          emit(state.update(
              isloading: false, ibanGetCustomAccountsModel: response));
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
