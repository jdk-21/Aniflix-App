import 'dart:convert';
import 'package:aniflix_app/api/objects/Hoster.dart';
import 'package:aniflix_app/api/objects/anime/AnimeSeason.dart';
import 'package:aniflix_app/api/objects/chat/chatMessage.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:aniflix_app/api/objects/history/historyEpisode.dart';
import 'package:aniflix_app/api/objects/news/Notification.dart' as n;
import 'package:aniflix_app/api/objects/news/NotificationListData.dart';
import 'package:aniflix_app/api/objects/profile/Friend.dart';
import 'package:aniflix_app/api/objects/profile/UserAnimeListData.dart';
import 'package:aniflix_app/api/objects/profile/UserProfile.dart';
import 'package:aniflix_app/api/objects/profile/UserSettings.dart';
import 'package:aniflix_app/api/objects/profile/UserStats.dart';
import 'package:aniflix_app/api/objects/profile/UserSubData.dart';
import 'package:aniflix_app/api/objects/profile/UserWatchlistData.dart';
import 'package:aniflix_app/components/screens/calendar.dart';
import 'package:aniflix_app/components/screens/chat.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/review.dart';
import 'package:aniflix_app/components/screens/subbox.dart';
import 'package:aniflix_app/api/objects/calendar/CalendarDay.dart';
import 'package:aniflix_app/api/objects/Episode.dart';
import 'package:aniflix_app/api/objects/news/News.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/objects/LoginResponse.dart';
import 'package:aniflix_app/api/objects/subbox/SubEpisode.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/screens/home.dart';
import 'package:aniflix_app/components/screens/userlist.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';
import 'package:aniflix_app/components/screens/profil.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:aniflix_app/components/screens/animelist.dart';
import 'package:flutter/widgets.dart';
import 'objects/anime/Anime.dart';
import 'objects/allanime/genrewithshow.dart';
import 'package:http/http.dart' as http;

class APIManager {
  static LoginResponse login;

  static Future<List<News>> _getNews() async {
    List<News> news = [];
    var response = await _getRequest("news");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        news.add(News.fromJson(entry));
      }
    }
    return news;
  }

  static Future<List<Hoster>> getHoster() async {
    List<Hoster> hoster = [];
    var response = await _authGetRequest("hosters", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        hoster.add(Hoster.fromJson(entry));
      }
    }
    return hoster;
  }

  static Future<Calendardata> getCalendarData() async {
    List<CalendarDay> elements = [];
    var response = await _getRequest("airing");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        elements.add(CalendarDay.fromJson(entry));
      }
    }
    return Calendardata(elements);
  }

  static Future<Subdata> getSubData() async {
    List<SubEpisode> episodes = [];
    var response = await _authGetRequest("abos/abos/0", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        episodes.add(SubEpisode.fromJson(entry));
      }
    }
    return Subdata(episodes);
  }

  static Future<List<Episode>> getAirings() async {
    List<Episode> airings = [];
    var response = await _getRequest("show/airing/0");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        airings.add(Episode.fromJson(entry));
      }
    }

    return airings;
  }

  static Future<List<Show>> getNewShows() async {
    List<Show> newshows = [];
    var response = await _getRequest("show/new/0");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        newshows.add(Show.fromJson(entry));
      }
    }

    return newshows;
  }

  static Future<List<Show>> getDiscover() async {
    List<Show> discover = [];
    var response = await _getRequest("show/discover/0");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        discover.add(Show.fromJson(entry));
      }
    }

    return discover;
  }

  static Future<Anime> getAnime(String name) async {
    Anime anime;
    var response = await _authGetRequest("show/" + name, login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      anime = Anime.fromJson(json);
    }

    return anime;
  }

  static Future<List<Show>> getAllShows() async {
    List<Show> shows = [];
    var response = await _authGetRequest("show", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return shows;
  }

  static Future<List<Show>> searchShows(String search) async {
    List<Show> shows = [];
    var response = await _authPostRequest("show/search", login,
        bodyObject: {"search": search});

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return shows;
  }

  static Future<List<GenreWithShows>> getAllShowsByGenres() async {
    List<GenreWithShows> shows = [];
    var response = await _authGetRequest("show/genres", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = GenreWithShows.fromJson(entry);
        shows.add(show);
      }
    }

    return shows;
  }

  static Future<EpisodeInfo> getEpisode(
      String name, int season, int number) async {
    EpisodeInfo episode;
    var response = await _authGetRequest(
        "episode/show/" +
            name +
            "/season/" +
            season.toString() +
            "/episode/" +
            number.toString(),
        login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      episode = EpisodeInfo.fromJson(json);
    }

    return episode;
  }

  static Future<LoadInfo> getEpisodeInfo(
      String name, int season, int number) async {
    var info = await getEpisode(name, season, number);
    var user = await getUser();

    return LoadInfo(user, info);
  }

  static Future<AnimeSeason> setSeasonSeen(int seasonId) async {
    var response = await _authPostRequest(
        "show/set-season-seen/" + seasonId.toString(), login);
    AnimeSeason season;
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      season = AnimeSeason.fromJson(json);
    }
    return season;
  }

  static Future<AnimeSeason> setSeasonUnSeen(int seasonId) async {
    var response = await _authPostRequest(
        "show/set-season-unseen/" + seasonId.toString(), login);
    AnimeSeason season;
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      season = AnimeSeason.fromJson(json);
    }
    return season;
  }

  static Future<ReviewShow> getReviews(String name) async {
    ReviewShow review;
    var response = await _authGetRequest("show/reviews/" + name, login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      review = ReviewShow.fromJson(json);
    }

    return review;
  }

  static Future<ReviewInfo> getReviewInfo(String name) async {
    var info = await getReviews(name);
    var user = await getUser();

    return ReviewInfo(info, user);
  }

  static Future<Review> createReview(int show_id, String text) async {
    var response = await _authPostRequest("review", login,
        bodyObject: {"show_id": show_id.toString(), "text": text});
    var review;
    if (response.statusCode != 404) {
      var json = jsonDecode(response.body);
      review = Review.fromJson(json);
    }
    return review;
  }

  static void deleteReview(int id) {
    _authDeleteRequest("review/" + id.toString(), login);
  }

  static Future<List<Episode>> getContinue() async {
    List<Episode> continues = [];
    var response = await _authPostRequest("show/continue", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        continues.add(Episode.fromJson(entry));
      }
    }

    return continues;
  }

  static Future<List<Episode>> hideContinue(int show_id) async {
    await _authPostRequest("show/hide-continue/" + show_id.toString(), login);
    return getContinue();
  }

  static Future<Homedata> getHomeData() async {
    var continues = await getContinue();
    var airings = await getAirings();
    var newShows = await getNewShows();
    var discover = await getDiscover();
    return Homedata(continues, airings, newShows, discover);
  }

  static Future<AnimeListData> getAnimeListData() async {
    var allShows = await getAllShows();
    var allShowsWithGenres = await getAllShowsByGenres();
    return AnimeListData(allShows, allShowsWithGenres);
  }

  static Future<LoginResponse> loginRequest(String email, String pw) async {
    var response =
        await _postRequest("auth/login", {"email": email, "password": pw});
    login = LoginResponse.fromJson(jsonDecode(response.body));
    return login;
  }

  static Future<User> getUser() async {
    var response = await _authPostRequest("user/me", login);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      if (response.statusCode >= 500 && response.statusCode < 600) {
        throw Exception(
            "Die App ist derzeit Offline, versuche es bitte später wieder.");
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        return null;
      }

      throw Exception("Status Code: " + response.statusCode.toString());
    }
  }

  static Future<UserProfile> getUserProfile(int userID) async {
    var response = await _authGetRequest("user/" + userID.toString(), login);
    return UserProfile.fromJson(jsonDecode(response.body));
  }

  static Future<UserStats> getUserStats(int userID) async {
    var response =
        await _authGetRequest("userstats/" + userID.toString(), login);
    return UserStats.fromJson(jsonDecode(response.body));
  }

  static Future<Historydata> getUserHistory(int userID) async {
    List<HistoryEpisode> episodes = [];
    var response = await _authPostRequest(
        "show/history/" + userID.toString() + "/0", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var episode = HistoryEpisode.fromJson(entry);
        episodes.add(episode);
      }
    }
    return Historydata(episodes);
  }

  static Future<Favouritedata> getUserFavorites(int userID) async {
    List<Show> shows = [];
    var response =
        await _authGetRequest("favorites/" + userID.toString(), login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = Show.getShows(json);
    }
    return Favouritedata(shows);
  }

  static Future<UserSubData> getUserSubs(int userID) async {
    List<Show> shows = [];
    var response = await _authGetRequest("abos/" + userID.toString(), login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = Show.getShows(json);
    }
    return UserSubData(shows);
  }

  static Future<UserAnimeListData> getUserSeen(int userID) async {
    List<UserSeenShow> shows = [];
    var response =
        await _authPostRequest("show/seen?user_id=" + userID.toString(), login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = UserSeenShow.getShows(json);
    }
    return UserAnimeListData(shows);
  }

  static Future<UserWatchlistData> getUserWatchlist(int userID) async {
    List<Show> shows = [];
    var response =
        await _authGetRequest("watchlist/" + userID.toString(), login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = Show.getShows(json);
    }
    return UserWatchlistData(shows);
  }

  static Future<UserProfileData> getUserProfileData(int userID) async {
    var profile = await getUserProfile(userID);
    var stats = await getUserStats(userID);
    var history = await getUserHistory(userID);
    var favourite = await getUserFavorites(userID);
    var sub = await getUserSubs(userID);
    var watchlist = await getUserWatchlist(userID);
    var friendlistdata = await getUserFriends(userID);
    return UserProfileData(
        profile, stats, history, favourite, sub, watchlist, friendlistdata);
  }

  static updateSettings(UserSettings settings) async {
    var response = await _authPatchRequest(
        "user/settings/" + settings.id.toString(), login,
        bodyObject: {
          "show_friends": settings.show_friends ? "1" : "0",
          "show_watchlist": settings.show_watchlist ? "1" : "0",
          "show_abos": settings.show_abos ? "1" : "0",
          "show_favorites": settings.show_favorites ? "1" : "0",
          "show_list": settings.show_list ? "1" : "0",
          "preferred_lang": settings.preferred_lang,
          "preferred_hoster_id": settings.preferred_hoster_id.toString()
        });
    print(response.statusCode);
    print(response.body);
  }

  static updateAboutMe(String message) {
    _authPatchRequest("user/user-about-me", login,
        bodyObject: {"about_me": message});
  }

  static updateName(String name) {
    _authPatchRequest("user/user-update", login,
        bodyObject: {"name": name, "about_me": ""});
  }

  static updatePassword(int id, String pw) {
    _authPatchRequest("user/update-passwort/" + id.toString(), login,
        bodyObject: {"password": pw});
  }

  static Future<FriendListData> getUserFriends(int userID) async {
    var response = await _authGetRequest(
        "friend/user/friends?id=" + userID.toString(), login);
    List<Friend> friends = [];
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      friends = Friend.getFriends(json);
    }
    return FriendListData(friends);
  }

  static addFriend(int friendId) {
    _authPostRequest("friend/create", login,
        bodyObject: {"friend_id": friendId.toString()});
  }

  static confirmFriendRequest(int id) {
    _answerFriendRequest(id, 0);
  }

  static blockFriendRequest(int id) {
    _answerFriendRequest(id, 2);
  }

  static _answerFriendRequest(int id, int status) {
    _authPostRequest("friend/update/" + id.toString(), login,
        bodyObject: {"status": status.toString()});
  }

  static cancelFriendRequest(int friendId) {
    _authDeleteRequest("friend/destroy?id=" + friendId.toString(), login);
  }

  static Future<UserListData> getUserList() async {
    var response = await _authGetRequest("user", login);
    return UserListData(User.getUsers(jsonDecode(response.body)));
  }

  static Future<NotificationListData> getNotifications() async {
    var response = await _authGetRequest("notification", login);
    var news = await _getNews();
    return NotificationListData(
        news, n.Notification.getNotifications(jsonDecode(response.body)));
  }

  static deleteNotification(int id) {
    _authDeleteRequest("notification/delete?id=" + id.toString(), login);
  }

  static addRecommendNotification(User user, User friend, Anime anime) {
    _postRequest("notification/user/create", {
      "user_id": friend.id.toString(),
      "text": "Dir wurde von " +
          user.name +
          " der Anime " +
          anime.name +
          " empfohlen. Schau ihn dir doch mal an.",
      "link": "/show/" + anime.name.toLowerCase().replaceAll(" ", "-")
    });
  }

  static void setShowVote(int showID, int previous_vote, int value) {
    _authPostRequest("vote/show/" + showID.toString(), login, bodyObject: {
      "value": value.toString(),
      "previous_vote": previous_vote.toString()
    });
  }

  static void setEpisodeVote(int episodeID, int previous_value, int new_value) {
    _authPostRequest("vote/episode/" + episodeID.toString(), login,
        bodyObject: {
          "previous_value": previous_value.toString(),
          "new_value": new_value.toString()
        });
  }

  static void setCommentVote(int commentID, int previous_value, int new_value) {
    _authPostRequest("vote/comment/" + commentID.toString(), login,
        bodyObject: {
          "previous_value": previous_value.toString(),
          "new_value": new_value.toString()
        });
  }

  static Future<Comment> addComment(int episodeID, String text) async {
    var response = await _authPostRequest("comment", login, bodyObject: {
      "text": text,
      "commentable_type": "Episode",
      "commentable_id": episodeID.toString()
    });
    var result;
    if (response.statusCode != 404) {
      result = Comment.fromJson(jsonDecode(response.body));
    }
    return result;
  }

  static void deleteComment(int id) {
    _authDeleteRequest("comment/" + id.toString(), login);
  }

  static void reportComment(int id, String text) {
    _authPostRequest("report", login, bodyObject: {
      "reportable_type": "Comment",
      "reportable_id": id.toString(),
      "text": text
    });
  }

  static void reportEpisode(int id, String text) {
    _authPostRequest("report", login, bodyObject: {
      "reportable_type": "Episode",
      "reportable_id": id.toString(),
      "text": text
    });
  }

  static Future<SubComment> addSubComment(int commentID, String text) async {
    var response = await _authPostRequest("comment", login, bodyObject: {
      "text": text,
      "commentable_type": "Comment",
      "commentable_id": commentID.toString()
    });
    var result;
    if (response.statusCode != 404) {
      result = SubComment.fromJson(jsonDecode(response.body));
    }
    return result;
  }

  static void setSubscription(int showID, bool newValue) {
    if (newValue) {
      _authPostRequest("abos/" + showID.toString() + "/subscribe", login);
    } else {
      _authPostRequest("abos/" + showID.toString() + "/unsubscribe", login);
    }
  }

  static void setWatchlist(int showID, bool newValue) {
    if (newValue) {
      _authPostRequest("watchlist/" + showID.toString() + "/add", login);
    } else {
      _authPostRequest("watchlist/" + showID.toString() + "/remove", login);
    }
  }

  static Future<Watchlistdata> getWatchlist() async {
    List<Show> shows = [];
    var response = await _authGetRequest("watchlist", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return Watchlistdata(shows);
  }

  static Future<Historydata> getHistory() async {
    List<HistoryEpisode> episodes = [];
    var response = await _authPostRequest("show/history", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var episode = HistoryEpisode.fromJson(entry);
        episodes.add(episode);
      }
    }

    return Historydata(episodes);
  }

  static void setFavourite(int showID, bool newValue) {
    if (newValue) {
      _authPostRequest("favorites/" + showID.toString() + "/add", login);
    } else {
      _authPostRequest("favorites/" + showID.toString() + "/remove", login);
    }
  }

  static Future<Favouritedata> getFavourite() async {
    List<Show> shows = [];
    var response = await _authGetRequest("favorites", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return Favouritedata(shows);
  }

  static Future<List<ChatMessage>> getChatMessages() async {
    List<ChatMessage> messages = [];
    var response = await _authGetRequest("chat/1/0", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var message = ChatMessage.fromJson(entry);
        messages.add(message);
      }
    }

    return messages;
  }

  static Future<ChatInfo> getChatInfo() async {
    var info = await getChatMessages();
    var user = await getUser();

    return ChatInfo(info, user);
  }

  static Future<ChatMessage> addMessage(String text) async {
    var result = await _authPostRequest("chat", login,
        bodyObject: {"chat_id": "1", "message": text});
    var json = jsonDecode(result.body);
    return ChatMessage.fromJson(json);
  }

  static Future<http.Response> _getRequest(String query) {
    return http.get('https://www2.aniflix.tv/api/' + query);
  }

  static Future<http.Response> _postRequest(String query, bodyObject) {
    return http.post('https://www2.aniflix.tv/api/' + query, body: bodyObject);
  }

  static Future<http.Response> _authPatchRequest(
      String query, LoginResponse user,
      {bodyObject = const {}}) {
    Map<String, String> headers = {
      "Authorization": user.token_type + " " + user.access_token
    };
    return http.patch('https://www2.aniflix.tv/api/' + query,
        body: bodyObject, headers: headers);
  }

  static Future<http.Response> _authDeleteRequest(
      String query, LoginResponse user) {
    Map<String, String> headers = {
      "Authorization": user.token_type + " " + user.access_token
    };
    return http.delete('https://www2.aniflix.tv/api/' + query,
        headers: headers);
  }

  static Future<http.Response> _authPostRequest(
      String query, LoginResponse user,
      {bodyObject = const {}}) {
    Map<String, String> headers = {
      "Authorization": user.token_type + " " + user.access_token
    };
    return http.post('https://www2.aniflix.tv/api/' + query,
        body: bodyObject, headers: headers);
  }

  static Future<http.Response> _authGetRequest(
      String query, LoginResponse user) {
    Map<String, String> headers = {
      "Authorization": user.token_type + " " + user.access_token
    };
    return http.get('https://www2.aniflix.tv/api/' + query, headers: headers);
  }
}
