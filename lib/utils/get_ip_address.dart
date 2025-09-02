import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/cupertino.dart';

class GetIPAddress {
  static final GetIPAddress _singleton = GetIPAddress._internal();

  factory GetIPAddress() {
    return _singleton;
  }

  GetIPAddress._internal();

  Future<String> getIps() async {
    String ipAddress = '';
    try {
      // for (var interface in await NetworkInterface.list()) {
      //   debugPrint('== Interface: ${interface.name} ==');
      //   for (var addr in interface.addresses) {
      //     debugPrint('******************************IP address ******************************');
      //     debugPrint(
      //         '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      //     ipAddress = addr.address;
      //     return ipAddress;
      //   }
      // }

      ipAddress = await Ipify.ipv4();

      debugPrint(
          '******************************IP address ******************************');
      debugPrint(ipAddress.toString());
    } catch (e) {
      debugPrint('getIps catch exp: $e');
      return '';
    }

    return ipAddress;
  }
}
