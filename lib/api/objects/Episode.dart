import 'dart:core';

import 'package:aniflix_app/api/objects/Season.dart';
import 'package:aniflix_app/api/objects/Stream.dart';

class Episode {
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
  int seen;
  List<AnimeStream> streams;
  Season season;

  Episode(
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
      this.seen,
      this.streams,
      this.season);

  factory Episode.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return Episode(
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
        (json["seen"] == null)?0:int.parse(json["seen"].toString()),
        AnimeStream.getStreams(json["streams"]),
        Season.fromJson(json["season"]));
  }

  static List<Episode> getEpisodes(List<dynamic> json) {
    List<Episode> episodes = [];
    if(json != null){
      for (var entry in json) {
        var episode = Episode.fromJson(entry);
        if (episode != null) episodes.add(episode);
      }
    }
    return episodes;
  }
}
