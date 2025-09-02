import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as Loc;
import 'package:permission_handler/permission_handler.dart';

class LocationDeniedScreen extends StatefulWidget {
  static const id = 'LocationDeniedScreen';

  @override
  _LocationDeniedScreenState createState() => _LocationDeniedScreenState();
}

class _LocationDeniedScreenState extends State<LocationDeniedScreen> {
  @override
  void initState() {
    super.initState();
  }

  PermissionStatus _permissionStatus = PermissionStatus.denied;
  Loc.Location location = Loc.Location();

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      debugPrint(status.toString());
      _permissionStatus = status;
      debugPrint(_permissionStatus.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          // resizeToAvoidBottomPadding: false, // this avoids the overflow error
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off_rounded,
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                const Text(
                  'You have to allow location to use this app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'pop'),
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: () async {
                    Permission.location.request();

                    if (await Permission.location.isDenied ||
                        await Permission.location.isPermanentlyDenied) {
                      Geolocator.openLocationSettings();
                    }

                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.refresh,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
