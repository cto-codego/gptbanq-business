
class PushModel {
  int  ?status;
  String ?message;
  String ? kycid;
  String ? page ='';

  PushModel({
    this.status,
    this.message,
    this.kycid,
    this.page
  });

  factory PushModel.fromJson(Map<String, dynamic> json) {
    return PushModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
      kycid: json['kyc_request_id'],
     page: json['page'] ?? '',

    );
  }
}
