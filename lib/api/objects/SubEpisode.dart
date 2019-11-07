import './Stream.dart';
class SubEpisode{
  int id;
  String name;
  String created_at;
  String cover_landscape;
  int season_id;
  int show_id;
  String show_name;
  int season_number;
  int episode_number;
  String show_url;
  String avgVotes;
  int hasReports;
  List<AnimeStream> streams;

  SubEpisode(this.id,this.name,this.created_at,this.cover_landscape,this.season_id,this.show_id,this.show_name,this.season_number,this.episode_number,this.show_url,this.avgVotes,this.hasReports,this.streams);
  factory SubEpisode.fromJson(Map<String, dynamic> json) {
    return SubEpisode(
        json["id"],
        json["name"],
        json["created_at"],
        json["cover_landscape"],
        json["season_id"],
        json["show_id"],
        json["show_name"],
        json["season_number"],
        json["episode_number"],
        json["show_url"],
        json["avgVotes"],
        json["hasReports"],
        AnimeStream.getStreams(json["streams"])
    );
  }
}