class SetUserPinResponseModel {
  int ? status;
  String ?userId, token, message;
  // {"status":1,”user_id”:”erewrrertrtryytyt3434ttrghjj”,”token”:”dewerwrereeretrt”}

  SetUserPinResponseModel({
    this.status,
    this.userId,
    this.token,
    this.message,
  });

  factory SetUserPinResponseModel.fromJson(Map<String, dynamic> json) {
    return SetUserPinResponseModel(
      status: json['status'],
      userId: json['user_id'] ?? '',
      token: json['token'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
