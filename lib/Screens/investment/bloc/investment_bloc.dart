import 'package:gptbanqbusiness/Models/cdg/cdg_accounts_model.dart';
import 'package:gptbanqbusiness/Models/cdg/cdg_dashboard_model.dart';
import 'package:gptbanqbusiness/Models/cdg/cdg_device_list_model.dart';
import 'package:gptbanqbusiness/Models/cdg/cdg_profit_log_model.dart';
import 'package:gptbanqbusiness/Models/investment/buy_master_node_model.dart';
import 'package:gptbanqbusiness/Models/investment/node_check_module_model.dart';
import 'package:gptbanqbusiness/Models/investment/node_logs_model.dart';
import 'package:gptbanqbusiness/Models/investment/node_profit_log_model.dart';
import 'package:gptbanqbusiness/Models/status_model.dart';
import 'package:gptbanqbusiness/Screens/investment/bloc/investment_repo.dart';
import 'package:gptbanqbusiness/utils/api_exception.dart';
import 'package:gptbanqbusiness/utils/connectivity_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../Models/cdg/cdg_qr_code_model.dart';
import '../../../Models/stake/iban_get_custom_account_model.dart';
import '../models/cdg_stake_list_model.dart';
import '../models/cdg_stake_overview_model.dart';
import '../models/unstake_model.dart';

part 'investment_event.dart';

part 'investment_state.dart';

class InvestmentBloc extends Bloc<InvestmentEvent, InvestmentState> {
  InvestmentBloc() : super(InvestmentState.init()) {
    on<InvestmentEvent>(mapEventToState);
  }

  InvestmentRepo investmentRepo = InvestmentRepo();

  void mapEventToState(
      InvestmentEvent event, Emitter<InvestmentState> emit) async {
    if (event is NodeCheckModuleEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.nodeCheckModule();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(
                state.update(isloading: false, nodeCheckModuleModel: response));
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
    } else if (event is NodeLogsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.nodeLogs();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, nodeLogsModel: response));
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
    } else if (event is NodeProfitLogsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await investmentRepo.nodeProfitLogs(orderId: event.orderId);

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, nodeProfitLogModel: response));
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
    } else if (event is BuyMasterNodeInfoEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.buyMasterNodeInfo();

          if (response is StatusModel) {
            emit(state.update(isloading: false, statusModel: response));
          } else {
            emit(state.update(isloading: false, buyMasterNodeModel: response));
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
    } else if (event is NodeOrderEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.orderMasterNode(
              numberOfNode: event.numberOfNode, ibanId: event.ibanId);

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
    } else if (event is SwiftTermsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.swiftTermsData(
              type: event.type, deviceType: event.deviceType);

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
          dynamic response = await investmentRepo.ibanGetCustomAccountDetails(
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
    /*CDG masternode section */
    else if (event is CdgDeviceListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgDeviceList();

          emit(state.update(isloading: false, cdgDeviceListModel: response));
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
    } else if (event is CdgAccountsEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgAccounts();

          emit(state.update(isloading: false, cdgAccountsModel: response));
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
    } else if (event is CdgActiveEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgActive(type: event.type);

          emit(state.update(isloading: false, cdgAccountsModel: response));
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
    } else if (event is CdgMasternodeOrderEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgMasternodeOrder(
            deviceId: event.deviceId,
            numberOfNode: event.numberOfNode,
            ibanId: event.ibanId,
            country: event.country,
            address: event.address,
            city: event.city,
            state: event.state,
            zipCode: event.zipCode,
            surnameOrCompany: event.surnameOrCompany,
            phone: event.phone,
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
    } else if (event is CdgDashboardEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgDashboard();

          emit(state.update(isloading: false, cdgDashboardModel: response));
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
    } else if (event is CdgProfitLogEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response =
              await investmentRepo.cdgProfitLog(orderId: event.orderId);

          emit(state.update(isloading: false, cdgProfitLogModel: response));
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
    } else if (event is CdgInviteEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgSendInvite(
              name: event.name, email: event.email);

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
    } else if (event is CdgQrCodeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgCheckQrCode(
            serialNumber: event.serialNumber,
          );

          emit(state.update(isloading: false, cdgQrCodeModel: response));
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
    } else if (event is CdgDeviceActiveEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgDeviceActive(
            serialNumber: event.serialNumber,
            cdgId: event.cdgId,
            iban: event.ibanId,
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
    } else if (event is CdgConvertEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgConvert(
            amount: event.amount,
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
    } else if (event is CdgStakeListEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgStakeList();

          emit(state.update(isloading: false, cdgStakeListModel: response));
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
    } else if (event is CdgStakeSelectedCdgIdEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgStakeSelected(
              stakeSelectedCdgId: event.cdgStakeSelectedCdgId);

          emit(state.update(isloading: false, cdgStakeOverviewModel: response));
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
    } else if (event is CdgStakePayNowEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgStakePayNow(
            stakeSelectedCdgId: event.cdgStakeSelectedCdgId,
            bootPercentage: event.boostPercentage,
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
    } else if (event is CdgUnStakeEvent) {
      emit(state.update(isloading: true));

      try {
        if (ConnectivityManager.isNetworkAvailable) {
          dynamic response = await investmentRepo.cdgUnStake();

          emit(state.update(isloading: false, unStakeModel: response));
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
