import 'dart:convert';

import 'package:aniflix_app/api/objects/Session.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';

class WatchlistRequests {
  static Future<Watchlistdata> getWatchlist() async {
    List<Show> shows = [];
    var response = await AniflixRequest("watchlist").get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return Watchlistdata(shows);
  }
}
