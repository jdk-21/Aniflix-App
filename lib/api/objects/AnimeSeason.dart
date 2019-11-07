import './Episode.dart';
class AnimeSeason {
  int id;
  int number;
  int show_id;
  String type;
  String created_at;
  String updated_at;
  String deleted_at;
  int length;
  List<Episode> episodes;

  AnimeSeason(this.id, this.number, this.show_id, this.type, this.created_at,
      this.updated_at, this.deleted_at, this.length, this.episodes);

  factory AnimeSeason.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return AnimeSeason(
        json["id"],
        json["number"],
        json["show_id"],
        json["type"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["length"],
        Episode.getEpisodes(json["episodes"])
    );
  }

  static List<AnimeSeason> getSeasons(List<dynamic> json) {
    List<AnimeSeason> seasons = [];
    if(json != null){
      for (var entry in json) {
        var season = AnimeSeason.fromJson(entry);
        if(season != null) seasons.add(season);
      }
    }
    return seasons;
  }
}
