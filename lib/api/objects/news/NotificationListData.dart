import 'package:aniflix_app/api/objects/news/Notification.dart';

import 'News.dart';

class NotificationListData{
  List<News> news;
  List<Notification> notifications;
  NotificationListData(this.news,this.notifications);
}