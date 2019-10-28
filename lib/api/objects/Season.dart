import 'package:aniflix_app/api/objects/Show.dart';

class Season {
  int id;
  int number;
  int show_id;
  String type;
  String created_at;
  String updated_at;
  String deleted_at;
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
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["length"],
        Show.fromJson(json["show"])
    );
  }
}
