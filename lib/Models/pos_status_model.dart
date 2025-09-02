class PosstatusModel {
  int? status;
  String? message;
  int? ispos;

  PosstatusModel({this.status, this.message, this.ispos});

  factory PosstatusModel.fromJson(Map<String, dynamic> json) {
    return PosstatusModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
      ispos: json['is_pos'] ?? '',
    );
  }
}
