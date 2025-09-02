import 'package:gptbanqbusiness/Models/convert/convert_confirm_model.dart';
import 'package:gptbanqbusiness/Models/convert/convert_currency_list_model.dart';
import 'package:gptbanqbusiness/Models/convert/currency_rate_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Models/update_model.dart';
import 'package:gptbanqbusiness/Screens/currency_convert_screen/bloc/converter_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/api_exception.dart';
import '../../../utils/connectivity_manager.dart';

part 'converter_event.dart';

part 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  ConverterBloc() : super(ConverterState.init()) {
    on<ConverterEvent>(mapEventToState);
  }

  final ConverterRepository _converterRepository = ConverterRepository();

  void mapEventToState(
      ConverterEvent event, Emitter<ConverterState> emit) async {
    if (event is ConvertCurrencyListEvent) {
      emit(state.update(isLoading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _converterRepository.getConvertCurrencyList(
              buyCurrency: event.buyCurrency!);

          emit(state.update(
            isLoading: false,
            convertCurrencyListModel: data,
          ));
        } else {
          emit(state.update(isLoading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
      }
    } else if (event is CurrencyRateEvent) {
      emit(state.update(isLoading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _converterRepository.getCurrencyRate(
              sellCurrency: event.sellCurrency!,
              buyCurrency: event.buyCurrency!);

          emit(state.update(
            isLoading: false,
            currencyRateModel: data,
          ));
        } else {
          emit(state.update(isLoading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
      }
    }else if (event is CurrencyRateNoLoadingEvent) {
      emit(state.update(isLoading: false));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _converterRepository.getCurrencyRate(
              sellCurrency: event.sellCurrency!,
              buyCurrency: event.buyCurrency!);

          emit(state.update(
            isLoading: false,
            currencyRateModel: data,
          ));
        } else {
          emit(state.update(isLoading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
      }
    } else if (event is CurrencyConvertConfirmEvent) {
      emit(state.update(isLoading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic data = await _converterRepository.currencyConvertConfirm(
            sellCurrencyId: event.sellCurrencyId!,
            buyCurrencyId: event.buyCurrencyId!,
            amount: event.amount!,
          );

          emit(state.update(
            isLoading: false,
            convertConfirmModel: data,
          ));
        } else {
          emit(state.update(isLoading: false));
        }
      } on ApiException catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
        // ignore: use_rethrow_when_possible
        throw (e);
      } catch (e) {
        debugPrint(e.toString());
        emit(state.update(isLoading: false));
      }
    }
    //
    // if (event is opendialog) {
    //   if (event.open == false) {
    //     debugPrint("object");
    //
    //     emit(state.update(
    //       isloading: false,
    //       open: true,
    //     ));
    //   }
    // }
  }
}
