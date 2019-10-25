import 'dart:core';

import 'package:aniflix_app/api/objects/Season.dart';
import 'package:aniflix_app/api/objects/Stream.dart';

class Episode {
  int id;
  String name;
  int number;
  int season_id;
  int user_id;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  double avgVotes;
  int hasReports;
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
      this.streams,
      this.season);

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        json["id"],
        json["name"],
        json["number"],
        json["season_id"],
        json["user_id"],
        DateTime.parse(json["created_at"]),
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["deleted_at"]),
        json["avgVotes"],
        json["hasReports"],
        AnimeStream.getStreams(json["streams"]),
        Season.fromJson(json["season"]));
  }
}
