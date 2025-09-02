class NotificationResponse {
  String ?title, description, date, time;

  NotificationResponse({
    this.title,
    this.description,
    this.date,
    this.time,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
    );
  }
}
