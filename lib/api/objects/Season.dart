import 'package:aniflix_app/api/objects/Show.dart';

class Season {
  int id;
  int number;
  int show_id;
  String type;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  int length;
  Show show;

  Season(this.id, this.number, this.show_id, this.type, this.created_at,
      this.updated_at, this.deleted_at, this.length, this.show);

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
        json["id"],
        json["number"],
        json["show_id"],
        json["type"],
        DateTime.parse(json["created_at"]),
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["deleted_at"]),
        json["length"],
        Show.fromJson(json["show"]));
  }
}
