// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ApiException implements Exception {
  static const defaultErrorDetail = 'Something went wrong. Please try again.';
  DioError error;
  ApiException(
    this.error,
  ) {
    // ignore: unnecessary_this
    this.error = error;
  }
  String getDetail() {
    if (null == error.response) {
      return defaultErrorDetail;
    }
    if (!(null != error.response!.data && error.response!.data is Map)) {
      return defaultErrorDetail;
    }
    if (!error.response!.data.containsKey('errors')) {
      return defaultErrorDetail;
    }
    if (error.response!.data['errors'] is! List) {
      return defaultErrorDetail;
    }
    if (error.response!.data['errors'].length == 0) {
      return defaultErrorDetail;
    }
    debugPrint(error.response!.data['errors'][0].toString());
    return error.response!.data['errors'][0].toString();
  }

  @override
  String toString() {
    // TODO: implement toString
    // ignore: unnecessary_this
    return this.getDetail();
  }
}
