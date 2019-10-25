class Show {
  int id;
  String name;
  String name_alt;
  String url;
  String description;
  String cover_landscape;
  String cover_landscape_original;
  String cover_portrait;
  String visible_since;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  int howManyAbos;
  int seasonCount;
  double rating;
  int airing;

  Show(
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
      this.deleted_at,
      this.howManyAbos,
      this.seasonCount,
      this.rating,
      this.airing);

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
        json["id"],
        json["name"],
        json["name_alt"],
        json["url"],
        json["description"],
        json["cover_landscape"],
        json["cover_landscape_original"],
        json["cover_portrait"],
        json["visible_since"],
        DateTime.parse(json["created_at"]),
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["deleted_at"]),
        json["howManyAbos"],
        json["seasonCount"],
        json["rating"],
        json["airing"]);
  }
}
