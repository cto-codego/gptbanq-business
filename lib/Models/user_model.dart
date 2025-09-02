class UserModel {
  int ? userID;
  String ?errorMsg = '';
  int ?statusCode;

  UserModel({
    this.userID,
    this.errorMsg,
    this.statusCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": this.userID,
    };
  }

  factory UserModel.fromResponseJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      List errorJsonList = json['errors'];

      Map<String, dynamic> errorJson = errorJsonList[0];

      String errorMsg = errorJson["detail"];

      return UserModel(errorMsg: errorMsg);
    } else if (json['data']['attributes']['errors'] != null) {
      return UserModel(errorMsg: json['data']['attributes']['errors']);
    }

    return UserModel();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: json['user_id'] == null ? 0 : json['user_id'],
    );
  }
}
