import 'package:gptbanqbusiness/Models/Regula_model.dart';
import 'package:gptbanqbusiness/Models/Sendmone_model.dart';
import 'package:gptbanqbusiness/Models/binficary_model.dart';
import 'package:gptbanqbusiness/Models/push_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/wallet_transfer/wallet_transfer_iban_list_model.dart';
import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_respotary.dart';
import 'package:gptbanqbusiness/Screens/wallet_transfer_section/bloc/wallet_transfer_repo.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';


part 'wallet_transfer_event.dart';

part 'wallet_transfer_state.dart';

class WalletTransferBloc extends Bloc<WalletTransferEvent, WalletTransferState> {
  WalletTransferBloc() : super(WalletTransferState.init()) {
    on<WalletTransferEvent>(mapEventToState);
  }

  void mapEventToState(WalletTransferEvent event, Emitter<WalletTransferState> emit) async {
    WalletTransferRepo walletTransferRepo = WalletTransferRepo();

    if (event is WalletTransferIbanListEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic walletTransferIbanListData =
              await walletTransferRepo.walletTransferIbanList(ibanId: event.ibanId);

          emit(state.update(isloading: false, walletTransferIbanListModel: walletTransferIbanListData));
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
    } else if (event is WalletTransferMoveEvent) {
      emit(state.update(
        isloading: true,
      ));
      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic statusData =
              await walletTransferRepo.walletTransferMove(senderIbanId: event.senderIbanId, receiverIbanId: event.receiverIbanId, amount: event.amount);

          emit(state.update(isloading: false, statusModel: statusData));
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
