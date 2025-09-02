import 'dart:async';
import 'dart:convert';
import 'package:gptbanqbusiness/Models/application.dart';
import 'package:gptbanqbusiness/Screens/Splash_screen/Splash_screen.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/utils/get_ip_address.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as Loc;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Locationservece with WidgetsBindingObserver {
  check() async {
    WidgetsBinding.instance.addObserver(this);
    bool status = await Permission.location.isDenied;

    if (await Permission.location.isDenied ||
        await Permission.location.isPermanentlyDenied) {
      Application.navKey.currentState!
          .push(MaterialPageRoute(builder: (context) => const SplashScreen()));
    }
  }

  Loc.LocationData? currentLocation;

  void getCurrentLocation() async {
    Loc.Location location = Loc.Location();
    location.getLocation().then((location) {
      // sendlocation(location.latitude.toString(), location.longitude.toString());
    });
    location.onLocationChanged.listen(
      (newLoc) {
        // sendlocation(newLoc.latitude.toString(), newLoc.longitude.toString());
      },
    );
  }

  getbgcurruntlocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    )).listen((position) {
      debugPrint('current location $position');
    });
  }

  // Future sendlocation(String lat, long) async {
  //   String ipAddress = '';
  //   ipAddress = await GetIPAddress().getIps();
  //   String userId = await UserDataManager().getUserId() ?? '';
  //
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request(
  //       'POST', Uri.parse('https://webhook.codegotech.com/hooks/latlongs'));
  //   request.body = json.encode({
  //     "user_id": userId,
  //     "lat": lat,
  //     "long": long,
  //     "ipaddress": ipAddress,
  //     "screen": User.Screen
  //   });
  //
  //   debugPrint(request.body);
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     debugPrint(await response.stream.bytesToString());
  //   } else {
  //     debugPrint(response.reasonPhrase);
  //   }
  // }
}

class awit {}
