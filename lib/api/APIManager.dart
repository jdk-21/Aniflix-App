import 'dart:convert';
import 'dart:io';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/main.dart';
import 'package:aniflix_app/api/objects/calendar/CalendarDay.dart';
import 'package:aniflix_app/api/objects/Episode.dart';
import 'package:aniflix_app/api/objects/news/News.dart';
import 'package:aniflix_app/api/objects/Show.dart';
import 'package:aniflix_app/api/objects/LoginResponse.dart';
import 'package:aniflix_app/api/objects/subbox/SubEpisode.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/screens/home.dart';
import 'package:aniflix_app/components/screens/anime.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'objects/anime/Anime.dart';
import 'package:http/http.dart' as http;

class APIManager {
  static LoginResponse login;

  static Future<List<News>> getNews() async {
    List<News> news = [];
    var response = await _getRequest("news");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        news.add(News.fromJson(entry));
      }
    }
    return news;
  }

  static Future<List<CalendarDay>> getCalendarData() async {
    List<CalendarDay> elements = [];
    var response = await _getRequest("airing");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        elements.add(CalendarDay.fromJson(entry));
      }
    }
    return elements;
  }
  static Future<List<SubEpisode>> getSubData() async {
    List<SubEpisode> episodes = [];
    var response = await _authGetRequest("abos/abos/0",login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        episodes.add(SubEpisode.fromJson(entry));
      }
    }
    return episodes;
  }

  static Future<List<SliderElement>> getAirings(MainWidgetState state) async {
    List<SliderElement> airings = [];
    var response = await _getRequest("show/airing/0");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var ep = Episode.fromJson(entry);
        airings.add(SliderElement(
            name: ep.season.show.name +
                " S" +
                ep.season.number.toString() +
                "E" +
                ep.number.toString(),
            description: ep.updated_at,
            image: "https://www2.aniflix.tv/storage/" +
                ep.season.show.cover_landscape,
            onTap: () {
              state.changePage(EpisodeScreen(state,ep.season.show.url,ep.season.number,ep.number), 10);
            }));
      }
    }

    return airings;
  }

  static Future<List<SliderElement>> getNewShows(MainWidgetState state) async {
    List<SliderElement> newshows = [];
    var response = await _getRequest("show/new/0");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        newshows.add(SliderElement(
            name: show.name,
            image: "https://www2.aniflix.tv/storage/" + show.cover_portrait,
          onTap: () {
            state.changePage(AnimeScreen(show.url), 10);
          },
        ));
      }
    }

    return newshows;
  }

  static Future<List<SliderElement>> getDiscover(MainWidgetState state) async {
    List<SliderElement> discover = [];
    var response = await _getRequest("show/discover/0");

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var show = Show.fromJson(entry);
        discover.add(SliderElement(
            name: show.name,
            image: "https://www2.aniflix.tv/storage/" + show.cover_portrait,
          onTap: () {
            state.changePage(AnimeScreen(show.url), 10);
          },));
      }
    }

    return discover;
  }
  static Future<Anime> getAnime(String name) async {
    Anime anime;
    var response = await _authGetRequest("show/"+name,login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      anime = Anime.fromJson(json);
    }

    return anime;
  }
  static Future<EpisodeInfo> getEpisode(String name,int season, int number) async {
    EpisodeInfo episode;
    var response = await _authGetRequest("episode/show/"+name+"/season/"+season.toString()+"/episode/"+number.toString(),login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      episode = EpisodeInfo.fromJson(json);
    }

    return episode;
  }

  static Future<List<SliderElement>> getContinue(MainWidgetState state) async {
    List<SliderElement> continues = [];
    var response = await _authPostRequest("show/continue", login);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var ep = Episode.fromJson(entry);
        continues.add(SliderElement(
            name: ep.season.show.name +
                " S" +
                ep.season.number.toString() +
                "E" +
                ep.number.toString(),
            description: ep.updated_at,
            image: "https://www2.aniflix.tv/storage/" +
                ep.season.show.cover_landscape,
            onTap: () {
              state.changePage(EpisodeScreen(state,ep.season.show.url,ep.season.number,ep.number), 10);
            }));
      }
    }

    return continues;
  }

  static Future<Homedata> getHomeData(MainWidgetState state) async {
    var continues = await getContinue(state);
    var airings = await getAirings(state);
    var newShows = await getNewShows(state);
    var discover = await getDiscover(state);
    return Homedata(continues,airings, newShows, discover);
  }

  static Future<LoginResponse> loginRequest(String email, String pw) async {
    var response =
    await _postRequest("auth/login", {"email": email, "password": pw});
    login = LoginResponse.fromJson(jsonDecode(response.body));
    return login;
  }

  static Future<User> getUser() async {
    var response = await _authPostRequest("user/me", login);
    return User.fromJson(jsonDecode(response.body));
  }

  static Future<http.Response> _getRequest(String query) {
    return http.get('https://www2.aniflix.tv/api/' + query);
  }

  static Future<http.Response> _postRequest(String query, bodyObject) {
    return http.post('https://www2.aniflix.tv/api/' + query, body: bodyObject);
  }

  static Future<http.Response> _authPostRequest(
      String query, LoginResponse user,
      {bodyObject = const {}}) {
    Map<String, String> headers = {
      "Authorization": user.token_type + " " + user.access_token
    };
    return http.post('https://www2.aniflix.tv/api/' + query,
        body: bodyObject, headers: headers);
  }

  static Future<http.Response> _authGetRequest(
      String query, LoginResponse user) {
    Map<String, String> headers = {
      "Authorization": user.token_type + " " + user.access_token
    };
    return http.get('https://www2.aniflix.tv/api/' + query, headers: headers);
  }
}
