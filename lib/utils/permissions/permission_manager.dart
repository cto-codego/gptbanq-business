import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_operator_info/mobile_operator_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:dart_ipify/dart_ipify.dart';

import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../assets.dart';
import '../input_fields/custom_color.dart';

class PermissionManager {
  static final PermissionManager _instance = PermissionManager._internal();

  factory PermissionManager() => _instance;

  PermissionManager._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();
  final LocalAuthentication _auth = LocalAuthentication();
  final NetworkInfo _networkInfo = NetworkInfo();
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  final Connectivity _connectivity = Connectivity();

  // Static method to check permissions and show bottom sheet if needed
  static Future<void> checkAndRequestPermissions(
    BuildContext context, {
    Function(String)? onDataCollected,
    bool forceShowBottomSheet = false,
  }) async {
    final manager = PermissionManager();
    final permissionStates = {
      'battery': false,
      'biometrics': false,
      'location': false,
      'phone': false,
    };

    // Collect data
    final data = await manager.collectDataWithPermissions(context);

    // Check for missing data
    bool hasMissingData = false;
    if (data['battery']?.containsKey('error') ?? true) {
      permissionStates['battery'] = false;
      hasMissingData = true;
    } else {
      permissionStates['battery'] = true;
    }
    if (data['biometrics']?.containsKey('error') ?? true) {
      permissionStates['biometrics'] = false;
      hasMissingData = true;
    } else {
      permissionStates['biometrics'] = true;
    }
    if (data['location']?.containsKey('error') ?? true) {
      permissionStates['location'] = false;
      hasMissingData = true;
    } else {
      permissionStates['location'] = true;
    }
    if (data['carrierInfo']?.containsKey('error') ?? true) {
      permissionStates['phone'] = false;
      hasMissingData = true;
    } else {
      permissionStates['phone'] = true;
    }

    // Convert data to JSON and call callback
    final jsonData = jsonEncode(data);
    onDataCollected?.call(jsonData);

    // Show bottom sheet if data is missing or forced
    if ((hasMissingData || forceShowBottomSheet) && context.mounted) {
      await _showPermissionBottomSheet(context, permissionStates,
          (permission, value) async {
        await manager._handlePermissionToggle(permission, value);
        final newData = await manager.collectDataWithPermissions(context);
        onDataCollected?.call(jsonEncode(newData));
      });
    }
  }

  Future<Map<String, dynamic>> collectDataWithPermissions(
      BuildContext context) async {
    final data = <String, dynamic>{};

    await _collectDeviceInfo(data);
    await _collectBatteryInfo(data, context);
    await _collectBiometricInfo(data, context);
    await _collectLocationAndNetworkInfo(data, context);
    await _collectPublicIPAndVPNStatus(data, context);
    await _collectCarrierInfo(data, context);

    return data;
  }

  Future<void> _collectDeviceInfo(Map<String, dynamic> data) async {
    try {
      final info = await _deviceInfo.deviceInfo;
      final deviceData = Map<String, dynamic>.from(info.data);
      deviceData.remove('systemFeatures');
      data['deviceInfo'] = deviceData;
    } catch (e) {
      data['deviceInfo'] = {'error': e.toString()};
    }
  }

  Future<void> _collectBatteryInfo(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryStatus = await _battery.batteryState;
      data['battery'] = {
        'level': batteryLevel,
        'status': batteryStatus.toString(),
      };
    } catch (e) {
      final batteryLevel = await _battery.batteryLevel;
      final batteryStatus = await _battery.batteryState;
      data['battery'] = {
        'level': batteryLevel,
        'status': batteryStatus.toString(),
      };
    }
  }

  Future<void> _collectBiometricInfo(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      final bioSupported = await _auth.isDeviceSupported();
      final availableBiometrics = await _auth.getAvailableBiometrics();

      // Initialize values
      final Map<String, bool> availableMethods = {};
      bool hasFace = false;
      bool hasFingerprint = false;

      for (var biometric in availableBiometrics) {
        final method = biometric.toString().split('.').last;
        availableMethods[method] = true;

        if (biometric == BiometricType.face) {
          hasFace = true;
        } else if (biometric == BiometricType.fingerprint) {
          hasFingerprint = true;
        }
      }

      data['biometrics'] = {
        'supported': bioSupported,
        'hasFace': hasFace,
        'hasFingerprint': hasFingerprint,
      };
    } catch (e) {
      data['biometrics'] = {'error': e.toString()};
    }
  }

  Future<void> _collectLocationAndNetworkInfo(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      final serviceEnabled = await _geolocator.isLocationServiceEnabled();
      final locationPermission = await _geolocator.checkPermission();

      if (serviceEnabled &&
          (locationPermission == LocationPermission.always ||
              locationPermission == LocationPermission.whileInUse)) {
        final position = await _geolocator.getCurrentPosition();
        data['location'] = {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'altitude': position.altitude,
          'speed': position.speed,
          'speedAccuracy': position.speedAccuracy,
          'heading': position.heading,
          'timestamp': position.timestamp.toIso8601String(),
        };

        final connectivityResult = await _connectivity.checkConnectivity();
        String? wifiName;
        try {
          wifiName = await _networkInfo.getWifiName();
        } catch (e) {
          debugPrint('Failed to get WiFi name: $e');
        }

        data['network'] = {
          'connectionType': connectivityResult.toString(),
          'wifiName': wifiName,
        };
      } else {
        data['location'] = {'error': 'Location permission not granted'};
        data['network'] = {'error': 'Location permission not granted'};
      }
    } catch (e) {
      data['location'] = {'error': e.toString()};
      data['network'] = {'error': e.toString()};
    }
  }

  Future<void> _collectPublicIPAndVPNStatus(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        data['publicIP'] = {'error': 'No internet connection'};
        data['vpnStatus'] = {'error': 'No internet connection'};
        return;
      }

      String? localIP;
      try {
        localIP = await _networkInfo.getWifiIP();
      } catch (e) {
        debugPrint('Failed to get local IP: $e');
      }

      final ipv4 = await Ipify.ipv4().timeout(Duration(seconds: 5));
      final ipv6 = await Ipify.ipv64()
          .timeout(Duration(seconds: 5))
          .catchError((_) => null);
      data['publicIP'] = {
        'ipv4': ipv4,
        'ipv6': ipv6,
      };

      // VPN detection using ConnectionStatusSingleton logic
      bool? isVPN;
      if (connectivityResult == ConnectivityResult.mobile) {
        isVPN = false;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        isVPN = false;
      } else if (connectivityResult == ConnectivityResult.vpn) {
        isVPN = true;
      } else {
        isVPN = false;
      }
      bool hasInternet = await _checkInternetConnection();
      data['vpnStatus'] = {
        'isVPNActive': isVPN,
        'localIP': localIP,
        'hasInternet': hasInternet,
        'connectionType': connectivityResult.toString(),
      };
    } catch (e) {
      data['publicIP'] = {'error': e.toString()};
      data['vpnStatus'] = {'error': e.toString()};
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.com')
          .timeout(const Duration(milliseconds: 100));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  Future<void> _collectCarrierInfo(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get country from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final carrierInfo = await MobileOperatorInfo().getMobileOperatorInfo();

      if (Platform.isAndroid) {
        data['carrierInfo'] = {
          'carrierName': carrierInfo.networkOperatorName,
          'countryCode': placemarks.isNotEmpty
              ? placemarks.first.isoCountryCode
              : carrierInfo.mobileCountryCode,
          'mobileCountryCode': carrierInfo.mobileCountryCode,
          'mobileNetworkCode': carrierInfo.mobileNetworkCode,
        };
      } else if (Platform.isIOS) {
        data['carrierInfo'] = {
          'carrierName': carrierInfo.networkOperatorName,
          'countryCode': carrierInfo.mobileCountryCode,
          'mobileCountryCode': carrierInfo.mobileCountryCode,
          'mobileNetworkCode': carrierInfo.mobileNetworkCode,
        };
      }
    } catch (e) {
      data['carrierInfo'] = {'error': e.toString()};
    }
  }

  Future<void> _handlePermissionToggle(String permission, bool value) async {
    if (!value) return; // Only handle enabling permissions

    switch (permission) {
      case 'location':
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await Geolocator.openLocationSettings();
          return;
        }
        final permissionStatus = await Geolocator.requestPermission();
        if (permissionStatus == LocationPermission.deniedForever) {
          await openAppSettings();
        }
        break;
    }
  }

  static Future<void> _showPermissionBottomSheet(
    BuildContext context,
    Map<String, bool> permissionStates,
    Function(String, bool) onPermissionChanged,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PermissionBottomSheet(
        permissionStates: permissionStates,
        onPermissionChanged: onPermissionChanged,
      ),
    );
  }
}

class _PermissionBottomSheet extends StatefulWidget {
  final Map<String, bool> permissionStates;
  final Function(String, bool) onPermissionChanged;

  const _PermissionBottomSheet({
    required this.permissionStates,
    required this.onPermissionChanged,
  });

  @override
  State<_PermissionBottomSheet> createState() => _PermissionBottomSheetState();
}

class _PermissionBottomSheetState extends State<_PermissionBottomSheet> {
  late Map<String, bool> _permissionStates;

  @override
  void initState() {
    super.initState();
    _permissionStates = Map.from(widget.permissionStates);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CustomColor.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CustomImageWidget(
                    imagePath: StaticAssets.closeBlack,
                    imageType: 'svg',
                    height: 24,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Manage Permissions',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: CustomColor.black,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    openAppSettings();
                  },
                  child: CustomImageWidget(
                    imagePath: StaticAssets.setting,
                    imageType: 'svg',
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildPermissionToggle(
            context,
            'Location Services',
            'Allow access to location and network information',
            'location',
          ),
          const Spacer(),
          PrimaryButtonWidget(
            onPressed: () => Navigator.pop(context),
            buttonText: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionToggle(
    BuildContext context,
    String title,
    String subtitle,
    String permissionKey,
  ) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: CustomColor.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: CustomColor.black,
        ),
      ),
      trailing: Switch(
        activeColor: CustomColor.primaryColor,
        activeTrackColor: CustomColor.primaryColor.withOpacity(0.2),
        inactiveTrackColor: CustomColor.black.withOpacity(0.2),
        inactiveThumbColor: CustomColor.black.withOpacity(0.5),
        value: _permissionStates[permissionKey] ?? false,
        onChanged: (value) {
          setState(() => _permissionStates[permissionKey] = value);
          widget.onPermissionChanged(permissionKey, value);
        },
      ),
    );
  }
}
