import 'package:aniflix_app/api/objects/Show.dart';

class CalendarShow {
  int id;
  int show_id;
  int season;
  int day;
  String details;
  String created_at;
  String updated_at;
  String deleted_at;
  Show show;

  CalendarShow(this.id, this.show_id, this.season, this.day, this.details,
      this.created_at, this.updated_at, this.deleted_at, this.show);
  factory CalendarShow.fromJson(Map<String, dynamic> json) {
    return CalendarShow(json["id"], json["show_id"], json["season"], json["day"], json["details"], json["created_at"], json["updated_at"], json["deleted_at"], Show.fromJson(json["show"]));
  }
}