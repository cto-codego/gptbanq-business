import 'dart:convert';
import 'dart:math';

import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/cupertino.dart';

class DeviceIMEI {
  Future<String> creatrandom() async {
    try {
      String imei = await UserDataManager().getImei();

      if (imei == null || imei == '') {
        final Random _random = Random.secure();

        var values = List<int>.generate(32, (i) => _random.nextInt(256));

        UserDataManager().saveImei(base64Url.encode(values));

        return base64Url.encode(values);
      } else {
        return imei;
      }
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}
