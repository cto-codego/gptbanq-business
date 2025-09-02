class NoResponseModel {
  int? status;
  String? message;
  String? page = '';

  NoResponseModel({this.status, this.message, this.page});

  factory NoResponseModel.fromJson(Map<String, dynamic> json) {
    return NoResponseModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
      page: json['page'] ?? '',
    );
  }
}
