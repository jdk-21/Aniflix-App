import 'dart:convert';

import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/history/historyEpisode.dart';
import 'package:aniflix_app/api/objects/profile/Friend.dart';
import 'package:aniflix_app/api/objects/profile/UserAnimeListData.dart';
import 'package:aniflix_app/api/objects/profile/UserProfile.dart';
import 'package:aniflix_app/api/objects/profile/UserSettings.dart';
import 'package:aniflix_app/api/objects/profile/UserStats.dart';
import 'package:aniflix_app/api/objects/profile/UserSubData.dart';
import 'package:aniflix_app/api/objects/profile/UserWatchlistData.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/profil.dart';
import 'package:aniflix_app/components/screens/userlist.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';

class ProfileRequests {
  static Future<User> getUser() async {
    var response = await AniflixRequest("user/me").post();
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      if (response.statusCode >= 500 && response.statusCode < 600) {
        throw Exception(
            "Die App ist derzeit Offline, versuche es bitte später wieder.");
      }

      print(response.statusCode);
      print(CacheManager.session.access_token);
      if (response.statusCode == 401 || response.statusCode == 403) {
        return null;
      }

      throw Exception("Status Code: " + response.statusCode.toString());
    }
  }

  static Future<UserProfile> _getUserProfile(int userID) async {
    var response = await AniflixRequest("user/" + userID.toString()).get();
    return UserProfile.fromJson(jsonDecode(response.body));
  }

  static Future<UserStats> _getUserStats(int userID) async {
    var response = await AniflixRequest("userstats/" + userID.toString()).get();
    return UserStats.fromJson(jsonDecode(response.body));
  }

  static Future<Historydata> _getUserHistory(int userID) async {
    List<HistoryEpisode> episodes = [];
    var response =
        await AniflixRequest("show/history/" + userID.toString() + "/0").post();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var episode = HistoryEpisode.fromJson(entry);
        episodes.add(episode);
      }
    }
    return Historydata(episodes);
  }

  static Future<Favouritedata> _getUserFavorites(int userID) async {
    List<Show> shows = [];
    var response = await AniflixRequest("favorites/" + userID.toString()).get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = Show.getShows(json);
    }
    return Favouritedata(shows);
  }

  static Future<UserSubData> getUserSubs(int userID) async {
    List<Show> shows = [];
    var response = await AniflixRequest("abos/" + userID.toString()).get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = Show.getShows(json);
    }
    return UserSubData(shows);
  }

  static Future<UserAnimeListData> getUserSeen(int userID) async {
    List<UserSeenShow> shows = [];

    var response =
        await AniflixRequest("show/seen?user_id=" + userID.toString()).post();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = UserSeenShow.getShows(json);
    }
    return UserAnimeListData(shows);
  }

  static Future<UserWatchlistData> _getUserWatchlist(int userID) async {
    List<Show> shows = [];
    var response = await AniflixRequest("watchlist/" + userID.toString()).get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      shows = Show.getShows(json);
    }
    return UserWatchlistData(shows);
  }

  static Future<FriendListData> getUserFriends(int userID) async {
    var response =
        await AniflixRequest("friend/user/friends?id=" + userID.toString())
            .get();
    List<Friend> friends = [];
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      friends = Friend.getFriends(json);
    }
    return FriendListData(friends);
  }

  static Future<UserProfileData> getUserProfileData(int userID) async {
    var profile = await _getUserProfile(userID);
    var stats = await _getUserStats(userID);
    var history = await _getUserHistory(userID);
    var favourite = await _getUserFavorites(userID);
    var sub = await getUserSubs(userID);
    var watchlist = await _getUserWatchlist(userID);
    var friendlistdata = await getUserFriends(userID);
    return UserProfileData(
        profile, stats, history, favourite, sub, watchlist, friendlistdata);
  }

  static updateSettings(UserSettings settings) async {
    var response =
        await AniflixRequest("user/settings/" + settings.id.toString())
            .patch(bodyObject: {
      "show_friends": settings.show_friends ? "1" : "0",
      "show_watchlist": settings.show_watchlist ? "1" : "0",
      "show_abos": settings.show_abos ? "1" : "0",
      "show_favorites": settings.show_favorites ? "1" : "0",
      "show_list": settings.show_list ? "1" : "0",
      "preferred_lang": settings.preferred_lang,
      "preferred_hoster_id": settings.preferred_hoster_id.toString()
    });
  }

  static Future<UserProfile> updateAvatar(String imagePath) async {
    var response = await AniflixRequest("user/set-avatar")
        .multipartFilePost("avatar", imagePath);
    return UserProfile.fromJson(response.data);
  }

  static Future<UserProfile> updateBackground(
      int settingsID, String imagePath) async {
    var response = await AniflixRequest(
            "user/settings/background_image/" + settingsID.toString())
        .multipartFilePost("", imagePath);
    return UserProfile.fromJson(response.data);
  }

  static Future<UserProfile> deleteBackground(int settingsID) async {
    var response = await AniflixRequest(
            "user/settings/background_image/" + settingsID.toString())
        .delete();
    var json = jsonDecode(response.body);
    return UserProfile.fromJson(json);
  }

  static updateAboutMe(String message) {
    AniflixRequest("user/user-about-me")
        .patch(bodyObject: {"about_me": message});
  }

  static updateName(String name) {
    AniflixRequest("user/user-update")
        .patch(bodyObject: {"name": name, "about_me": ""});
  }

  static updatePassword(int id, String pw) {
    AniflixRequest("user/update-passwort/" + id.toString())
        .patch(bodyObject: {"password": pw});
  }

  static addFriend(int friendId) {
    AniflixRequest("friend/create")
        .post(bodyObject: {"friend_id": friendId.toString()});
  }

  static confirmFriendRequest(int id) {
    _answerFriendRequest(id, 0);
  }

  static blockFriendRequest(int id) {
    _answerFriendRequest(id, 2);
  }

  static _answerFriendRequest(int id, int status) {
    AniflixRequest("friend/update/" + id.toString())
        .post(bodyObject: {"status": status.toString()});
  }

  static cancelFriendRequest(int friendId) {
    AniflixRequest("friend/destroy?id=" + friendId.toString()).delete();
  }

  static Future<UserListData> getUserList() async {
    var response = await AniflixRequest("user").get();
    return UserListData(User.getUsers(jsonDecode(response.body)));
  }
}
