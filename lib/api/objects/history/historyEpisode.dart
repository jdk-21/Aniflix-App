import 'dart:core';

import 'package:aniflix_app/api/objects/Season.dart';
import 'package:aniflix_app/api/objects/Stream.dart';

class HistoryEpisode {
  int id;
  String name;
  int number;
  int season_id;
  int user_id;
  String created_at;
  String updated_at;
  String deleted_at;
  String avgVotes;
  int hasReports;
  List<AnimeStream> streams;
  Season season;
  String seen;

  HistoryEpisode(
      this.id,
      this.name,
      this.number,
      this.season_id,
      this.user_id,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.avgVotes,
      this.hasReports,
      this.streams,
      this.season,
      this.seen);

  factory HistoryEpisode.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return HistoryEpisode(
        json["id"],
        json["name"],
        json["number"],
        json["season_id"],
        json["user_id"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["avgVotes"],
        json["hasReports"],
        AnimeStream.getStreams(json["streams"]),
        Season.fromJson(json["season"]),
        json["pivot"]["created_at"]);
  }

  static List<HistoryEpisode> getEpisodes(List<dynamic> json) {
    List<HistoryEpisode> episodes = [];
    if(json != null){
      for (var entry in json) {
        var episode = HistoryEpisode.fromJson(entry);
        if (episode != null) episodes.add(episode);
      }
    }
    return episodes;
  }
}
