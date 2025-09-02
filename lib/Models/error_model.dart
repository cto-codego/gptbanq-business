class ErrorModel {
  int ?status;
  String ?errorMessage;

  ErrorModel({
    this.status,
    this.errorMessage,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      status: json['status'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}
