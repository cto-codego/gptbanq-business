import 'package:gptbanqbusiness/Models/notification.dart';

class NotificationsModel {
  int? status;
  String? message;
  List<NotificationResponse>? notifications;

  NotificationsModel({
    this.status,
    this.message,
    this.notifications,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    List<NotificationResponse> notifications = [];

    if (json['status'] == 1) {
      json['notification'].asMap().forEach((index, item) {
        notifications.add(NotificationResponse.fromJson(item));
      });
    }

    return NotificationsModel(
      status: json['status'],
      notifications: notifications,
      message: json['message'] ?? '',
    );
  }
}
