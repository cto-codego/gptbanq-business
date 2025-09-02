import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSt {
  static final SecureSt _singleton = SecureSt._internal();

  factory SecureSt() {
    return _singleton;
  }

  SecureSt._internal();

  FlutterSecureStorage getInstance() {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return storage;
  }
}
