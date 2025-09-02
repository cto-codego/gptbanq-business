class SignUpResponseModel {
  int ? status;
  String ? userId, message;

  SignUpResponseModel({
    this.status,
    this.userId,
    this.message,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      status: json['status'] ?? '',
      userId: json['user_id'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
