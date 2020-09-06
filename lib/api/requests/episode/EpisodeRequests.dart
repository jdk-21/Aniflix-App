import 'dart:convert';

import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/api/requests/user/ProfileRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/episode.dart';

class EpisodeRequests {
  static Future<EpisodeInfo> _getEpisode(
      String name, int season, int number) async {
    EpisodeInfo episode;

    var response = await AniflixRequest(
            "episode/show/" +
                name +
                "/season/" +
                season.toString() +
                "/episode/" +
                number.toString(),
            type: AniflixRequestType.Prefers_Login)
        .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      episode = EpisodeInfo.fromJson(json);
    }

    return episode;
  }

  static Future<LoadInfo> getEpisodeInfo(
      String name, int season, int number) async {
    var info = await _getEpisode(name, season, number);
    var user = CacheManager.userData;

    return LoadInfo(user, info);
  }

  static void setEpisodeVote(
      int episodeID, int previous_value, int new_value) {
    AniflixRequest("vote/episode/" + episodeID.toString()).post(
        bodyObject: {
          "previous_value": previous_value.toString(),
          "new_value": new_value.toString()
        });
  }

  static void setCommentVote(
      int commentID, int previous_value, int new_value) {
    AniflixRequest("vote/comment/" + commentID.toString()).post(
        bodyObject: {
          "previous_value": previous_value.toString(),
          "new_value": new_value.toString()
        });
  }

  static Future<Comment> addComment(
      int episodeID, String text) async {
    var response =
        await AniflixRequest("comment").post(bodyObject: {
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
    AniflixRequest("comment/" + id.toString()).delete();
  }

  static void reportComment(int id, String text) {
    AniflixRequest("report").post(bodyObject: {
      "reportable_type": "Comment",
      "reportable_id": id.toString(),
      "text": text
    });
  }

  static void reportEpisode(int id, String text) {
    AniflixRequest("report").post(bodyObject: {
      "reportable_type": "Episode",
      "reportable_id": id.toString(),
      "text": text
    });
  }

  static Future<SubComment> addSubComment(
      int commentID, String text) async {
    var response =
        await AniflixRequest("comment").post(bodyObject: {
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
}
