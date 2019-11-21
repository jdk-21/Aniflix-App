import '../Show.dart';
class GenreWithShows{
  int id;
  String name;
  String created_at;
  String updated_at;
  String deleted_at;
  List<Show> shows;

  GenreWithShows(this.id,this.name,this.created_at,this.updated_at,this.deleted_at,this.shows);
  factory GenreWithShows.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return GenreWithShows(
        json["id"],
        json["name"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
      Show.getShows(json["shows"])
    );
  }
}