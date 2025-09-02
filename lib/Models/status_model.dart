class StatusModel {
  int? status;
  String? message;
  String? page = '';

  StatusModel({this.status, this.message, this.page});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
      page: json['page'] ?? '',
    );
  }
}
