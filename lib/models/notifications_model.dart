class NotificationsModel {
  NotificationsModel({
    required this.title,
    required this.body,
    this.data,
  });

  String title;
  String body;
  String? data;
}
