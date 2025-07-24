class NotificationData {
  NotificationData({
    required this.app,
    required this.description,
    required this.date,
  });

  String app;
  String description;
  String date;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        app: json["app"] ?? '',
        description: json["discription"] ?? '',
        date: json["date"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "app": app,
        "discription": description,
        "date": date,
      };
}
