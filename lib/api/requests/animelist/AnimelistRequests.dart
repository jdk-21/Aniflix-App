import 'dart:convert';

import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/objects/allanime/genrewithshow.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/components/screens/animelist.dart';

class AnimelistRequests {
  static Future<List<Show>> _getAllShows() async {
    List<Show> shows = [];
    var response =
        await AniflixRequest("show", type: AniflixRequestType.No_Login).get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        shows.add(show);
      }
    }

    return shows;
  }

  static Future<List<GenreWithShows>> _getAllShowsByGenres() async {
    List<GenreWithShows> shows = [];
    var response =
        await AniflixRequest("show/genres", type: AniflixRequestType.No_Login)
            .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = GenreWithShows.fromJson(entry);
        shows.add(show);
      }
    }

    return shows;
  }

  static Future<AnimeListData> getAnimeListData() async {
    var allShows = await _getAllShows();
    var allShowsWithGenres = await _getAllShowsByGenres();
    return AnimeListData(allShows, allShowsWithGenres);
  }
}
