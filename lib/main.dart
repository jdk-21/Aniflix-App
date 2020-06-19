import 'dart:io';

import 'package:aniflix_app/api/objects/LoginResponse.dart';
import 'package:aniflix_app/components/screens/animelist.dart';
import 'package:aniflix_app/components/screens/calendar.dart';
import 'package:aniflix_app/components/screens/chat.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/home.dart';
import 'package:aniflix_app/components/screens/news.dart';
import 'package:aniflix_app/components/screens/profilesettings.dart';
import 'package:aniflix_app/components/screens/profilesubbox.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/components/screens/settings.dart';
import 'package:aniflix_app/components/screens/subbox.dart';
import 'package:aniflix_app/components/screens/userlist.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';
import 'package:aniflix_app/components/screens/profil.dart';
import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';
import './components/screens/login.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'components/screens/anime.dart';
import 'components/screens/loading.dart';
import 'components/screens/review.dart';
import 'components/screens/search.dart';

void main() async {
  runApp(App());
}

bool isDesktop() {
  return !(Platform.isAndroid || Platform.isIOS);
}

class App extends StatefulWidget {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['aniflix', 'anime', 'weeb', 'japan'],
      contentUrl: 'https://www2.aniflix.tv/',
      childDirected: false);
  App({
    Key key,
  }) : super(key: key);

  @override
  AppState createState() => new AppState();

  static void setTheme(BuildContext context, int i) {
    AppState state = context.ancestorStateOfType(TypeMatcher<AppState>());
    var manager = ThemeManager.getInstance();
    String old = manager.actualTheme.getThemeName();
    manager.setActualTheme(i);
    if (state != null) {
      var analytics = AppState.analytics;
      if (!isDesktop()) {
        analytics.logEvent(name: "change_theme", parameters: {
          "old_theme": old,
          "new_theme": manager.actualTheme.getThemeName()
        });
      }

      state.setState(() {
        state._theme = manager.getActualThemeData();
      });
    }
  }
}

class AppState extends State<App> {
  ThemeData _theme = ThemeManager.getInstance().getActualThemeData();
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  AniflixNavState _navState;
  final PageStorageBucket bucket = PageStorageBucket();
  static int _index = 0;
  SharedPreferences _prefs;
  static bool _loading;
  static AppState _state;
  static bool _loggedIn;
  static bool adFailed;
  bool _adLoaded;
  BannerAd ad;

  AppState() {
    _loading = true;
    _loggedIn = false;
    _state = this;
    _adLoaded = false;
    adFailed = false;
    if (!isDesktop()) {
      analytics.logAppOpen();
    }else{
      adFailed = true;
    }
  }

  @override
  void initState() {
    HosterParser.initParser();
    super.initState();
    if (!isDesktop()) {
      FirebaseAdMob.instance
          .initialize(appId: "ca-app-pub-1740246956609068~4725713221")
          .then((init) {
        setState(() {
          ad = BannerAd(
              adUnitId: "ca-app-pub-1740246956609068/1140216654",
              size: AdSize.banner,
              targetingInfo: App.targetingInfo,
              listener: (MobileAdEvent event) {
                if (event == MobileAdEvent.failedToLoad) {
                  setState(() {
                    adFailed = true;
                  });
                }
                print("BannerAd event is $event");
              });
        });
      });
    }
  }

  static updateLoggedIn(bool value) {
    _state.setState(() {
      _loggedIn = value;
    });
  }

  static setLoading(bool value) {
    _state.setState(() {
      _loading = value;
    });
  }

  static setIndex(int value) {
    _index = value;
  }

  checkLoginStatus() {
    setState(() {
      _loggedIn = !(APIManager.login == null);
    });
  }

  showChat(BuildContext ctx) {
    Navigator.pushNamed(ctx, "chat");
  }

  @override
  Widget build(BuildContext buildcontext) {
    if (_prefs == null) {
      ThemeManager manager = ThemeManager.getInstance();
      if (!isDesktop()) {
        SharedPreferences.getInstance().then((prefs) {
          setState(() {
            manager.setActualTheme(prefs.getInt("actualTheme") ?? 0);
            _theme = ThemeManager.getInstance().getActualThemeData();
            _prefs = prefs;
            _loading = false;
            if (prefs.getString("access_token") != null &&
                prefs.getString("token_type") != null) {
              APIManager.login = LoginResponse(prefs.getString("access_token"),
                  prefs.getString("token_type"), null);
              _loggedIn = true;
            }
          });
        });
      } else {
        setState(() {
          manager.setActualTheme(0);
          _theme = ThemeManager.getInstance().getActualThemeData();
          _prefs = null;
          _loading = false;
        });
      }
    }
    if (_loading) {
      return MaterialApp(
        title: 'Aniflix',
        home: LoadingScreen(),
        color: _theme.backgroundColor,
        theme: _theme,
      );
    } else {
      if (_loggedIn) {
        if (ad != null) {
          if (!_adLoaded) {
            ad.load().then((loaded) {
              if (loaded) {
                _adLoaded = true;
                ad.show(anchorType: AnchorType.top, anchorOffset: 75);
                print("Show Ad!");
              }
            });
          }
        }
        return MaterialApp(
            title: 'Aniflix',
            color: _theme.backgroundColor,
            theme: _theme,
            navigatorObservers: (isDesktop()) ? [] : [observer],
            home: Builder(
              builder: (context) => getScaffold(Home(), context, button: true),
            ),
            routes: {
              'home': (context) {
                return getScaffold(Home(), context, button: true);
              },
              'search': (context) {
                return getScaffold(SearchAnime(), context, setIndex: true);
              },
              'news': (context) {
                return getScaffold(NewsPage(), context, setIndex: true);
              },
              'calendar': (context) {
                return getScaffold(Calendar(), context, setIndex: true);
              },
              'settings': (context) {
                return getScaffold(Settings(), context, setIndex: true);
              },
              'subbox': (context) {
                return getScaffold(SubBox(), context);
              },
              'animelist': (context) {
                return getScaffold(AnimeList(), context);
              },
              'history': (context) {
                return getScaffold(Verlauf(), context, setIndex: true);
              },
              'watchlist': (context) {
                return getScaffold(Watchlist(), context, setIndex: true);
              },
              'favourites': (context) {
                return getScaffold(Favoriten(), context, setIndex: true);
              },
              'chat': (context) {
                return getScaffold(ChatScreen(), context, setIndex: true);
              },
              'userlist': (context) {
                return getScaffold(Userlist(), context, setIndex: true);
              }
            },
            onGenerateRoute: generateRoute);
      } else {
        return MaterialApp(
          title: 'Aniflix',
          home: Scaffold(body: Login()),
          color: _theme.backgroundColor,
          theme: _theme,
        );
      }
    }
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "episode":
        EpisodeScreenArguments args = settings.arguments;
        return MaterialPageRoute(builder: (ctx) {
          return getScaffold(
              EpisodeScreen.withData(
                  args.name, args.season, args.number, args.episodeInfo),
              ctx,
              setIndex: true);
        });
      case "anime":
        return MaterialPageRoute(builder: (ctx) {
          return getScaffold(AnimeScreen(settings.arguments), ctx,
              setIndex: true);
        });
      case "review":
        return MaterialPageRoute(builder: (ctx) {
          return getScaffold(ReviewScreen(settings.arguments), ctx,
              setIndex: true);
        });
      case "profil":
        return MaterialPageRoute(builder: (ctx) {
          return getScaffold(new Profile(settings.arguments), ctx,
              setIndex: true);
        });
    }
  }

  Scaffold getScaffold(Screen widget, BuildContext ctx,
      {bool button = false, bool setIndex = false}) {
    if (setIndex) {
      _index = 3;
    }
    return Scaffold(
        appBar: AniflixAppbar(this, ctx),
        bottomNavigationBar: AniflixNavigationbar(_index, (navstate) {
          _navState = navstate;
        }, _theme),
        floatingActionButton: (button)
            ? FloatingActionButton(
                heroTag: null,
                backgroundColor: _theme.iconTheme.color,
                onPressed: () {
                  showChat(ctx);
                },
                child: Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
              )
            : Container(),
        body: widget);
  }
}
