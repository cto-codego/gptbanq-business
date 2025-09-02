class UserStatusModel {
  int? status, uploadVideo;
  static int? uploadVideoAsWell;
  static int? statusCode5;
  static int? isSetPin;
  int? sendlink;
  String? planlink;
  String? weburl;
  RejectedReason? rejectedReason;
  String? message;
  int? locationhide;

  int? isIdproof;
  int? isAddressproof;
  int? isSelfie;

  UserStatusModel({
    this.status,
    this.uploadVideo,
    this.weburl,
    this.sendlink,
    this.message,
    this.rejectedReason,
    this.planlink,
    this.locationhide,
    this.isIdproof,
    this.isAddressproof,
    this.isSelfie,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    uploadVideoAsWell = json['upload_video'];
    statusCode5 = json['status'];
    isSetPin = json['is_setpin'];
    return UserStatusModel(
      status: json['status'],
      uploadVideo: json['upload_video'],
      sendlink: json['sendlink'] ?? 222,
      message: json['message'] ?? '',
      planlink: json['plan_page_link'] ?? '',
      weburl: json['url'] ?? '',
      locationhide: json['locationhide'],
      isIdproof: json["is_idproof"],
      isAddressproof: json["is_addressproof"],
      isSelfie: json["is_selfie"],
      rejectedReason: json["rejected_reason"] == null
          ? RejectedReason(address: [], passport: [])
          : RejectedReason.fromJson(json["rejected_reason"]),
    );
  }
}

class RejectedReason {
  final List<String>? address;
  final List<String>? passport;

  RejectedReason({
    this.address,
    this.passport,
  });

  factory RejectedReason.fromJson(Map<String, dynamic> json) => RejectedReason(
        address: List<String>.from(json["address"].map((x) => x)),
        passport: List<String>.from(json["passport"].map((x) => x)),
      );
}
