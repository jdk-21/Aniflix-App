import 'package:aniflix_app/api/objects/Hoster.dart';
import 'package:aniflix_app/components/screens/animelist.dart';
import 'package:aniflix_app/components/screens/calendar.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/home.dart';
import 'package:aniflix_app/components/screens/subbox.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';
import 'package:aniflix_app/components/screens/userlist.dart';

class CacheManager{

  static Homedata homedata;
  static Subdata subdata;
  static AnimeListData animeListData;
  static User userData;
  static Calendardata calendardata;
  static Favouritedata favouritedata;
  static Historydata historydata;
  static Watchlistdata watchlistdata;
  static UserListData userlistdata;
  static List<Hoster> hosters;

  static clearAll(){
   CacheManager.homedata = null;
   CacheManager.subdata = null;
   CacheManager.animeListData = null;
   CacheManager.userData = null;
   CacheManager.calendardata = null;
   CacheManager.favouritedata = null;
   CacheManager.historydata = null;
   CacheManager.watchlistdata = null;
   CacheManager.userlistdata = null;
   CacheManager.hosters = null;
  }

}