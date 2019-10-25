class Hoster {
  int id;
  String name;
  String logo;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  int preferred;

  Hoster(this.id, this.name, this.logo, this.created_at, this.deleted_at,
      this.updated_at, this.preferred);

  factory Hoster.fromJson(Map<String, dynamic> json) {
    return Hoster(
        json["id"],
        json["name"],
        json["logo"],
        DateTime.parse(json["created_at"]),
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["deleted_at"]),
        json["preferred"]);
  }
}
