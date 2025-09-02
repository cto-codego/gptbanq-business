class PayWithModel {
  int? status;
  String? message;
  String? page = '';

  PayWithModel({this.status, this.message, this.page});

  factory PayWithModel.fromJson(Map<String, dynamic> json) {
    return PayWithModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
      page: json['page'] ?? '',
    );
  }
}
