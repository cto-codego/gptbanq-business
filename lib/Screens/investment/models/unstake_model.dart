class UnStakeModel {
  int? status;
  String? message;
  String? page = '';

  UnStakeModel({this.status, this.message, this.page});

  factory UnStakeModel.fromJson(Map<String, dynamic> json) {
    return UnStakeModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
      page: json['page'] ?? '',
    );
  }
}
