import 'dart:convert';

import 'package:aniflix_app/api/objects/anime/Anime.dart';
import 'package:aniflix_app/api/objects/anime/AnimeSeason.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';

class AnimeRequests {
  static Future<Anime> getAnime(String name) async {
    Anime anime;
    var response = await AniflixRequest("show/" + name,
            type: AniflixRequestType.Prefers_Login)
        .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      anime = Anime.fromJson(json);
    }

    return anime;
  }

  static Future<AnimeSeason> setSeasonSeen(int seasonId) async {
    var response =
        await AniflixRequest("show/set-season-seen/" + seasonId.toString())
            .post();
    AnimeSeason season;
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      season = AnimeSeason.fromJson(json);
    }
    return season;
  }

  static Future<AnimeSeason> setSeasonUnSeen(int seasonId) async {
    var response =
        await AniflixRequest("show/set-season-unseen/" + seasonId.toString())
            .post();
    AnimeSeason season;
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      season = AnimeSeason.fromJson(json);
    }
    return season;
  }

  static void setShowVote(
    int showID,
    int previous_vote,
    int value,
  ) {
    AniflixRequest("vote/show/" + showID.toString()).post(bodyObject: {
      "value": value.toString(),
      "previous_vote": previous_vote.toString()
    });
  }

  static void setSubscription(int showID, bool newValue) {
    if (newValue) {
      AniflixRequest("abos/" + showID.toString() + "/subscribe").post();
    } else {
      AniflixRequest("abos/" + showID.toString() + "/unsubscribe").post();
    }
  }

  static void setWatchlist(int showID, bool newValue) {
    if (newValue) {
      AniflixRequest("watchlist/" + showID.toString() + "/add").post();
    } else {
      AniflixRequest("watchlist/" + showID.toString() + "/remove").post();
    }
  }

  static void setFavourite(int showID, bool newValue) {
    if (newValue) {
      AniflixRequest("favorites/" + showID.toString() + "/add").post();
    } else {
      AniflixRequest("favorites/" + showID.toString() + "/remove").post();
    }
  }
}
