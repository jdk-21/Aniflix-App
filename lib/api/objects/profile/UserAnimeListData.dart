class UserAnimeListData{
  List<UserSeenShow> shows;

  UserAnimeListData(this.shows);

}

class UserSeenShow {
  int id;
  String name;
  String name_alt;
  String url;
  String description;
  String cover_landscape;
  String cover_landscape_original;
  String cover_portrait;
  String visible_since;
  String created_at;
  String updated_at;
  String deleted_at;

  UserSeenShow(
      this.id,
      this.name,
      this.name_alt,
      this.url,
      this.description,
      this.cover_landscape,
      this.cover_landscape_original,
      this.cover_portrait,
      this.visible_since,
      this.created_at,
      this.updated_at,
      this.deleted_at);

  factory UserSeenShow.fromJson(Map<String, dynamic> json) {
    return UserSeenShow(
        json["id"],
        json["name"],
        json["name_alt"],
        json["url"],
        json["description"],
        json["cover_landscape"],
        json["cover_landscape_original"],
        json["cover_portrait"],
        json["visible_since"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"]
    );
  }
  static List<UserSeenShow> getShows(List<dynamic> json) {
    List<UserSeenShow> shows = [];
    if(json != null){
      for (var entry in json) {
        var show = UserSeenShow.fromJson(entry);
        if(show != null)shows.add(show);
      }
    }
    return shows;
  }
}