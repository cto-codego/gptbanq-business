import 'package:flutter/material.dart';

class Application {
  static final GlobalKey<NavigatorState> navKey =
      new GlobalKey<NavigatorState>();
  static String isBioMetric = '';
  static bool isBiometricsSupported = true;
  static String accountId = '';
  static bool isPassportProof = false;
}
