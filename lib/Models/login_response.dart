// Response : {"status":1,"message":"Please check your mail box. Confirm the login process",
// ”user_id”:”erewrrertrtryytyt3434ttrghjj”,”token”:”dewerwrereeretrt”}

class LoginResponse {
  int ?status;
  String? message, userId, token;
  var loginCode;

  LoginResponse({
    this.status,
    this.message,
    this.userId,
    this.token,
    this.loginCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'] ?? '',
      userId: json['user_id'] ?? '',
      token: json['token'] ?? '',
      loginCode: json['logincode'] ?? '',
    );
  }
}
