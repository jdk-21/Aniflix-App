import 'dart:convert';

import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/Anime.dart';
import 'package:aniflix_app/api/objects/news/News.dart';
import 'package:aniflix_app/api/objects/news/Notification.dart';
import 'package:aniflix_app/api/objects/news/NotificationListData.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/cache/cacheManager.dart';

class NotificationRequests {
  static Future<List<News>> _getNews() async {
    List<News> news = [];
    var response =
        await AniflixRequest("news", type: AniflixRequestType.No_Login).get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        news.add(News.fromJson(entry));
      }
    }
    return news;
  }

  static Future<List<Notification>> _getPersonalNotifications() async {
    var response = await AniflixRequest("notification").get();

    if (response.statusCode == 200) {
      return Notification.getNotifications(jsonDecode(response.body));
    }
    return null;
  }

  static Future<NotificationListData> getNotifications() async {
    var news = await _getNews();
    var notifications = (CacheManager.session != null)
        ? await _getPersonalNotifications()
        : null;
    return NotificationListData(news, notifications);
  }

  static deleteNotification(int id) {
    AniflixRequest("notification/delete?id=" + id.toString()).delete();
  }

  static addRecommendNotification(User user, User friend, Anime anime) {
    AniflixRequest("notification/user/create").post(bodyObject: {
      "user_id": friend.id.toString(),
      "text": "Dir wurde von " +
          user.name +
          " der Anime " +
          anime.name +
          " empfohlen. Schau ihn dir doch mal an.",
      "link": "/show/" + anime.name.toLowerCase().replaceAll(" ", "-")
    });
  }
}
