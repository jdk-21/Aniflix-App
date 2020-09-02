import 'dart:convert';

import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';

class SearchRequests {
  static Future<List<Show>> searchShows(String search) async {
    List<Show> shows = [];
    var response =
        await AniflixRequest("show/search", type: AniflixRequestType.No_Login)
            .post(bodyObject: {"search": search});

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return shows;
  }
}
