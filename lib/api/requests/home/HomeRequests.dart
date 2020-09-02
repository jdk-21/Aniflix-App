import 'dart:convert';

import 'package:aniflix_app/api/objects/Episode.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/home.dart';

class HomeRequests {
  static Future<List<Episode>> _getAirings() async {
    List<Episode> airings = [];
    var response =
        await AniflixRequest("show/airing/0", type: AniflixRequestType.No_Login)
            .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        airings.add(Episode.fromJson(entry));
      }
    }

    return airings;
  }

  static Future<List<Show>> _getNewShows() async {
    List<Show> newshows = [];
    var response =
        await AniflixRequest("show/new/0", type: AniflixRequestType.No_Login)
            .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        newshows.add(Show.fromJson(entry));
      }
    }

    return newshows;
  }

  static Future<List<Show>> _getDiscover() async {
    List<Show> discover = [];
    var response = await AniflixRequest("show/discover/0",
            type: AniflixRequestType.No_Login)
        .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        discover.add(Show.fromJson(entry));
      }
    }

    return discover;
  }

  static Future<List<Episode>> _getContinue() async {
    List<Episode> continues = [];
    var response = await AniflixRequest("show/continue").post();
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        continues.add(Episode.fromJson(entry));
      }
    }

    return continues;
  }

  static Future<List<Episode>> hideContinue(
      int show_id) async {
    await AniflixRequest("show/hide-continue/" + show_id.toString())
        .post();
    return _getContinue();
  }

  static Future<Homedata> getHomeData() async {
    var continues;
    if (CacheManager.session != null) continues = await _getContinue();
    var airings = await _getAirings();
    var newShows = await _getNewShows();
    var discover = await _getDiscover();
    return Homedata(continues, airings, newShows, discover);
  }
}
