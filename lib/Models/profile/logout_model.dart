class LogoutModel {
  int? status;
  String? message;
  String? page = '';

  LogoutModel({this.status, this.message, this.page});

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
      page: json['page'] ?? '',
    );
  }
}