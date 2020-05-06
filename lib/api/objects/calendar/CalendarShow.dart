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
  bool released;
  Show show;

  CalendarShow(this.id, this.show_id, this.season, this.day, this.details,
      this.created_at, this.updated_at, this.deleted_at,this.released, this.show);
  factory CalendarShow.fromJson(Map<String, dynamic> json) {
    return CalendarShow(json["id"], json["show_id"], json["season"], json["day"], json["details"], json["created_at"], json["updated_at"], json["deleted_at"],checkReleased(json), Show.fromJson(json["show"]));
  }

  static bool checkReleased(Map<String, dynamic> json){
    if(json["released"] == null) return false;
    if(json["released"] is List){
      var list = json["released"] as List;
      if(list.length > 0) return true;
    }
    return false;
  }

  static List<CalendarShow> getCalendarShows(List<dynamic> json) {
    List<CalendarShow> calendarshows = [];
    if(json != null){
      for (var entry in json) {
        calendarshows.add(CalendarShow.fromJson(entry));
      }
    }
    return calendarshows;
  }
}
