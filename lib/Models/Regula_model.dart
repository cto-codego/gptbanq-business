
class RegulaModel {
  int  ?status;
  String ?message;
  String ? page ='';

  RegulaModel({
    this.status,
    this.message,
    this.page
  });

  factory RegulaModel.fromJson(Map<String, dynamic> json) {
    return RegulaModel(
      status: json['status'] ?? 222,
      message: json['message'] ?? '',
     page: json['page'] ?? '',

    );
  }
}
