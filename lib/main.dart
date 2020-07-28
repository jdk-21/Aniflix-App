import 'package:aniflix_app/api/objects/LoginResponse.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/navigationbars/profilebar.dart';
import 'package:aniflix_app/components/screens/AppErrorScreen.dart';
import 'package:aniflix_app/components/screens/HomeViewSlider.dart';
import 'package:aniflix_app/components/screens/animelist.dart';
import 'package:aniflix_app/components/screens/calendar.dart';
import 'package:aniflix_app/components/screens/chat.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/news.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
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

const adUnitID = "ca-app-pub-1740246956609068/6617765772";

void main() async {
  runApp(App());
}

class App extends StatefulWidget {
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
      analytics.logEvent(name: "change_theme", parameters: {
        "old_theme": old,
        "new_theme": manager.actualTheme.getThemeName()
      });
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
  final PageStorageBucket bucket = PageStorageBucket();
  NativeAdmob _ad;
  PageController controller;
  static int _index = 0;
  static AniflixProfilebar _profileBar;
  SharedPreferences _prefs;
  static bool _loading;
  static String _error;
  static AppState _state;
  static bool _loggedIn;
  static bool _init;

  AppState() {
    _loading = true;
    _loggedIn = false;
    _init = false;
    _state = this;
    analytics.logAppOpen();
    controller = PageController();
  }

  @override
  void initState() {
    HosterParser.initParser();
    FlutterDownloader.initialize();
    _ad = NativeAdmob(
      adUnitID: adUnitID,
      loading: Center(child: CircularProgressIndicator()),
      error: ThemeText("Failed to load the ad"),
      controller: NativeAdmobController(),
      type: NativeAdmobType.banner,
      options:
          NativeAdmobOptions(ratingColor: Colors.red, showMediaContent: true),
    );
    super.initState();
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
    _state.setState(() {
      _index = value;
    });
  }

  static setProfileBar(AniflixProfilebar value) {
    _state.setState(() {
      _profileBar = value;
    });
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
    if (!_init) {
      ThemeManager manager = ThemeManager.getInstance();
      SharedPreferences.getInstance().then((prefs) {
        setState(() {
          _init = true;
          manager.setActualTheme(prefs.getInt("actualTheme") ?? 0);
          _theme = ThemeManager.getInstance().getActualThemeData();
          _prefs = prefs;
          if (prefs.getString("access_token") != null &&
              prefs.getString("token_type") != null) {
            APIManager.login = LoginResponse(prefs.getString("access_token"),
                prefs.getString("token_type"), null);
            APIManager.getUser()
                .then((value) => setState(() {
                      if (value != null) _loggedIn = true;
                      _loading = false;
                    }))
                .catchError((object, trace) {
              setState(() {
                _error = object.message;
                _loading = false;
              });
            });
          } else {
            _loading = false;
          }
        });
      });
    }
    if (_loading) {
      return MaterialApp(
        title: 'Aniflix',
        home: LoadingScreen(),
        color: _theme.backgroundColor,
        theme: _theme,
      );
    } else if (_error == null) {
      if (_loggedIn) {
        if (CacheManager.hosters == null) {
          APIManager.getHoster()
              .then((hosters) => CacheManager.hosters = hosters);
        }
        return MaterialApp(
            title: 'Aniflix',
            color: _theme.backgroundColor,
            theme: _theme,
            navigatorObservers: [observer],
            home: Builder(
              builder: (context) => getScaffold(
                  HomeViewSlider(controller), context,
                  bottomBar: AniflixNavigationbar(_index, controller, context),
                  button: true),
            ),
            routes: {
              'home': (context) {
                return getScaffold(HomeViewSlider(controller), context,
                    bottomBar:
                        AniflixNavigationbar(_index, controller, context),
                    button: true);
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
              },
              'login': (context) {
                return Scaffold(body: Login());
              },
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
    } else {
      return MaterialApp(
        title: 'Aniflix',
        home: Scaffold(
            body: AppErrorScreen(_error),
            backgroundColor: Theme.of(context).backgroundColor),
        color: _theme.backgroundColor,
        theme: _theme,
      );
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
              setIndex: true, bottomBar: _profileBar);
        });
    }
  }

  Scaffold getScaffold(Screen widget, BuildContext ctx,
      {bool button = false, bool setIndex = false, Widget bottomBar}) {
    if (setIndex) {
      _index = 3;
    }
    return Scaffold(
        appBar: AniflixAppbar(this, ctx),
        bottomNavigationBar: bottomBar,
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
        body: Column(children: [
          Container(
            child: _ad,
            width: MediaQuery.of(ctx).size.width,
            height: 50,
            color: Theme.of(ctx).backgroundColor,
          ),
          Expanded(child: widget)
        ]));
  }
}
