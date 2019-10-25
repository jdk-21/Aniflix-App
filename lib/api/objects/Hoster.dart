class Hoster {
  int id;
  String name;
  String logo;
  String created_at;
  String updated_at;
  String deleted_at;
  int preferred;

  Hoster(this.id, this.name, this.logo, this.created_at, this.deleted_at,
      this.updated_at, this.preferred);

  factory Hoster.fromJson(Map<String, dynamic> json) {
    return Hoster(
        json["id"],
        json["name"],
        json["logo"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["preferred"]);
  }
}
