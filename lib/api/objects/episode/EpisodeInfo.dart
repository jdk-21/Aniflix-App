import 'package:aniflix_app/api/objects/Season.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';

class EpisodeInfo{
  int id;
  String name;
  int number;
  int season_id;
  String created_at;
  String updated_at;
  String deleted_at;
  int voted;
  String previous;
  String next;
  String avgVotes;
  int hasReports;
  List<AnimeStream> streams;
  List<Comment> comments;
  List<Vote> votes;
  Season season;

  EpisodeInfo(this.id,this.name,this.number,this.season_id,this.created_at,this.updated_at,this.deleted_at,this.voted,this.previous,this.next,this.avgVotes,this.hasReports,this.streams,this.comments,this.votes,this.season);

  factory EpisodeInfo.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return EpisodeInfo(
        json["id"],
        json["name"],
        json["number"],
        json["season_id"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["voted"],
        json["previous"],
        json["next"],
        json["avgVotes"],
        json["hasReports"],
        AnimeStream.getStreams(json["streams"]),
        Comment.getComments(json["comments"]),
        Vote.getVotes(json["votes"]),
        Season.fromJson(json["season"])
    );
  }

}