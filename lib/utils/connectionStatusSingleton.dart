import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();

  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    var connectivityResult = await (Connectivity().checkConnectivity());
    checkConnection(connectivityResult, isFromSync: true);
  }

  Future<bool> isConnectedToInternet({bool isFromSync = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return await checkConnection(connectivityResult, isFromSync: isFromSync);
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection(result);
  }

  Future<bool> checkConnection(ConnectivityResult connectivityResult,
      {bool? isFromSync}) async {
    if (connectivityResult == ConnectivityResult.mobile) {
      hasConnection = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      hasConnection = true;
    } else if (connectivityResult == ConnectivityResult.vpn) {
      hasConnection = true;
    } else {
      hasConnection = false;
    }
    debugPrint('hasConnection: $hasConnection');
    return hasConnection;
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection2(ConnectivityResult connectivityResult,
      {bool? isFromSync}) async {
    bool previousConnection = hasConnection;
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.

      //The connection status changed send out an update to all listeners
      hasConnection = await _ifConnectionHaveEnoughSpeed(isFromSync!);
      if (previousConnection != hasConnection) {
        connectionChangeController.add(hasConnection);
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.

      //The connection status changed send out an update to all listeners
      connectionChangeController.add(hasConnection);
      hasConnection = await _ifConnectionHaveEnoughSpeed(isFromSync!);
      if (previousConnection != hasConnection) {
        connectionChangeController.add(hasConnection);
      }
    } else {
      hasConnection = false;
      connectionChangeController.add(false);
    }
    // print(hasConnection);
    return hasConnection;
  }

  Future<bool> _ifConnectionHaveEnoughSpeed(bool isFromSync) async {
    try {
      final result =
          await InternetAddress.lookup('www.google.com').timeout(const Duration(
        milliseconds: 100,
      ));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('Has Connection');
        hasConnection = true;
      } else {
        //  print('No Connection');
        hasConnection = false;
      }
    } on SocketException catch (_) {
      // print('No Connection');
      if (!isFromSync) {} //Get.dialog(internetNotAvailableDialoge());
      return false;
    } on TimeoutException catch (_) {
      // print('No Connection');
      if (!isFromSync) {} // Get.dialog(internetNotAvailableDialoge());
      return false;
    }
    return hasConnection;
  }
}
