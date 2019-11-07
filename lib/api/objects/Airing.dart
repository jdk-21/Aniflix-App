class Airing {
  int id;
  int show_id;
  int season;
  int day;
  String details;
  String created_at;
  String updated_at;
  String deleted_at;

  Airing(this.id, this.show_id, this.season, this.day,this.details, this.created_at,
      this.updated_at, this.deleted_at);

  factory Airing.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return Airing(
      json["id"],
      json["show_id"],
      json["season"],
      json["day"],
      json["details"],
      json["created_at"],
      json["updated_at"],
      json["deleted_at"],
    );
  }
}
