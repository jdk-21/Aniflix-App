import 'package:aniflix_app/api/requests/anime/AnimeRequests.dart';
import 'package:aniflix_app/api/requests/anime/ReviewRequests.dart';
import 'package:aniflix_app/api/requests/animelist/AnimelistRequests.dart';
import 'package:aniflix_app/api/requests/calendar/CalendarRequests.dart';
import 'package:aniflix_app/api/requests/chat/ChatRequests.dart';
import 'package:aniflix_app/api/requests/episode/EpisodeRequests.dart';
import 'package:aniflix_app/api/requests/home/HomeRequests.dart';
import 'package:aniflix_app/api/requests/search/SearchRequests.dart';
import 'package:aniflix_app/api/requests/subbox/SubboxRequests.dart';
import 'package:aniflix_app/api/requests/user/LoginRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:flutter_test/flutter_test.dart';

const String name = "DommisTestUser";
const String email = "test@test.com";
const String pw = "test1234";
@Timeout(const Duration(minutes: 5))
void main() {
  group("Test login", () {
    test("Test invalid Login", () async {
      var session = await LoginRequests.loginRequest(email, "wrong_pw");
      expect(session, isNotNull);
      expect(session.error, "Unauthorized");
    });
    test("Test correct Login", () async {
      var session = await LoginRequests.loginRequest(email, pw);
      expect(session, isNotNull);
      expect(session.error, null);
      CacheManager.session = session;
    });
  });

  group("Test get requests", () {
    test("Test Calender", () async {
      var calender = await CalendarRequest.getCalendarData();
      expect(calender, isNotNull);
    });
  });
  group("Test auth get requests", () {
    test("Test HomeData", () async {
      var homedata = await HomeRequests.getHomeData();
      expect(homedata, isNotNull);
    });
    test("Test Subs", () async {
      var subs = await SubboxRequests.getSubData();
      expect(subs, isNotNull);
    });

    test("Test Anime", () async {
      var anime = await AnimeRequests.getAnime("dr-stone");
      expect(anime, isNotNull);
    });

    test("Test All Anime", () async {
      var allAnime = await AnimelistRequests.getAnimeListData();
      expect(allAnime, isNotNull);
    });

    test("Test Episode", () async {
      var episode = await EpisodeRequests.getEpisodeInfo("dr-stone", 1, 1);
      expect(episode, isNotNull);
    });

    test("Test Reviews", () async {
      var reviews = await ReviewRequests.getReviewInfo("dr-stone");
      expect(reviews, isNotNull);
    });

    test("Test Chat", () async {
      var chat = await ChatRequests.getChatInfo();
      expect(chat, isNotNull);
    });
  });

  group("Test auth post request", () {
    test("Test Search", () async {
      var search = await SearchRequests.searchShows("stone");
      expect(search, isNotNull);
    });
  });
}
