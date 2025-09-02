class UpdateModel {
  int? status;
  String? message;
  String? page = '';

  UpdateModel({this.status, this.message, this.page});

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      status: json['status'] ?? 222,
      message: json['status'] == 1 ? json['version'] : json['message'],
      page: json['page'] ?? '',
    );
  }
}
