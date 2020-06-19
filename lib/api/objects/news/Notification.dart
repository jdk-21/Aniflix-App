class Notification {
  int id;
  int user_id;
  String text;
  String link;
  String created_at;
  String updated_at;
  String deleted_at;

  Notification(
      this.id,
      this.user_id,
      this.text,
      this.link,
      this.created_at,
      this.updated_at,
      this.deleted_at);

  factory Notification.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Notification(
        json["id"],
        json["user_id"],
        json["text"],
        json["link"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"]);
  }

  static List<Notification> getNotifications(List<dynamic> json) {
    List<Notification> notifications = [];
    for (var entry in json) {
      notifications.add(Notification.fromJson(entry));
    }
    return notifications;
  }
}
