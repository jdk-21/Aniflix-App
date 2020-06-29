import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter_test/flutter_test.dart';

const String name = "DommisTestUser";
const String email = "test@test.com";
const String pw = "test1234";
void main() {

  group("Test login", () {
    test("Test invalid Login",() async {
      await APIManager.loginRequest(email, "wrong_pw");
      expect(APIManager.login, isNotNull);
      expect(APIManager.login.error, "Unauthorized");
    });
    test("Test Login",() async {
      await APIManager.loginRequest(email, pw);
      expect(APIManager.login, isNotNull);
      expect(APIManager.login.error, null);
    });
  });

  group("Test get requests", () {
    test("Test New Shows",() async {
      var newShows = await APIManager.getNewShows();
      expect(newShows, isNotNull);
    });

    test("Test Calender", () async {
      var calender = await APIManager.getCalendarData();
      expect(calender, isNotNull);
    });

    test("Test Airings", () async {
      var airings = await APIManager.getAirings();
      expect(airings, isNotNull);
    });

    test("Test Discover", () async {
      var discover = await APIManager.getDiscover();
      expect(discover, isNotNull);
    });
  });

  group("Test auth get requests", (){
    test("Test Subs", () async {
      var subs = await APIManager.getSubData();
      expect(subs, isNotNull);
    });

    test("Test Anime", () async {
      var anime = await APIManager.getAnime("dr-stone");
      expect(anime, isNotNull);
    });

    test("Test All Anime", () async {
      var allAnime = await APIManager.getAllShows();
      expect(allAnime, isNotNull);
    });

    test("Test All Anime By Genre", () async {
      var allAnimeGenre = await APIManager.getAllShowsByGenres();
      expect(allAnimeGenre, isNotNull);
    });

    test("Test Episode", () async {
      var episode = await APIManager.getEpisode("dr-stone", 1, 1);
      expect(episode, isNotNull);
    });

    test("Test Reviews", () async {
      var reviews = await APIManager.getReviews("dr-stone");
      expect(reviews, isNotNull);
    });

    test("Test Chat", () async {
      var chat = await APIManager.getChatMessages();
      expect(chat, isNotNull);
    });
  });

  group("Test auth post request", (){
    test("Test Search", () async {
      var search = await APIManager.searchShows("stone");
      expect(search, isNotNull);
    });

    /*test("Test Season Seen", () async {
      var seasonSeen = await APIManager.setSeasonSeen(123456);
      expect(seasonSeen, null);
    });

    test("Test Unseason Seen", () async {
      var seasonUnSeen = await APIManager.setSeasonUnSeen(123456);
      expect(seasonUnSeen, null);
    });

    test("Test Create Review", () async {
      var createReview = await APIManager.createReview(123456, "test");
      expect(createReview, null);
    });*/

  });


}
