import 'dart:convert';

import 'package:aniflix_app/api/objects/calendar/CalendarDay.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/components/screens/calendar.dart';

class CalendarRequest {
  static Future<Calendardata> getCalendarData() async {
    List<CalendarDay> elements = [];
    var response =
        await AniflixRequest("airing", type: AniflixRequestType.No_Login).get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        elements.add(CalendarDay.fromJson(entry));
      }
    }
    return Calendardata(elements);
  }
}
