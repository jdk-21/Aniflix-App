import 'dart:convert';

import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';

class FavouriteRequests {
  static Future<Favouritedata> getFavourite() async {
    List<Show> shows = [];
    var response = await AniflixRequest("favorites").get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return Favouritedata(shows);
  }
}
