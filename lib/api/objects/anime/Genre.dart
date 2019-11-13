class Genre{
  int id;
  String name;
  String created_at;
  String updated_at;
  String deleted_at;

  Genre(this.id,this.name,this.created_at,this.updated_at,this.deleted_at);
  factory Genre.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return Genre(
        json["id"],
        json["name"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"]);
  }

  static List<Genre> getGenres(List<dynamic> json) {
    List<Genre> genres = [];
    if(json != null){
      for (var entry in json) {
        var genre = Genre.fromJson(entry);
        if(genre != null)genres.add(genre);
      }
    }
    return genres;
  }

}