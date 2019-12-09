import 'package:aniflix_app/api/objects/LoginResponse.dart';
import 'package:aniflix_app/components/screens/chat.dart';
import 'package:aniflix_app/components/screens/home.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';
import './components/screens/login.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() async {
  ThemeManager manager = ThemeManager.getInstance();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  manager.setActualTheme(prefs.getInt("actualTheme") ?? 0);
  runApp(App());
}

class App extends StatefulWidget {
  App({
    Key key,
  }) : super(key: key);

  @override
  _AppState createState() => new _AppState();

  static void setTheme(BuildContext context, int i) {
    _AppState state = context.ancestorStateOfType(TypeMatcher<_AppState>());
    var analytics = _AppState.analytics;
    var manager = ThemeManager.getInstance();
    String old = manager.actualTheme.getThemeName();
    manager.setActualTheme(i);
    analytics.logEvent(name: "change_theme",parameters: {"old_theme":old,"new_theme": manager.actualTheme.getThemeName()});
    state.setState(() {
      state._theme = manager.getActualThemeData();
    });
  }
}

class _AppState extends State<App> {
  ThemeData _theme = ThemeManager.getInstance().getActualThemeData();
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =  FirebaseAnalyticsObserver(analytics: analytics);
  _AppState(){
    analytics.logAppOpen();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aniflix App',
      home: MainWidget(analytics,observer),
      theme: _theme,
      navigatorObservers: [
        observer
      ],
    );
  }
}

class MainWidget extends StatefulWidget {
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  static MainWidgetState of (BuildContext ctx) => ctx.ancestorStateOfType(const TypeMatcher<MainWidgetState>());
  MainWidget(this.analytics,this.observer);
  @override
  MainWidgetState createState() => MainWidgetState(this.analytics,this.observer);
}

class MainWidgetState extends State<MainWidget> {
  final FirebaseAnalyticsObserver observer;
final FirebaseAnalytics analytics;
  final PageStorageBucket bucket = PageStorageBucket();
  Screen _screen;
  int index = 0;

  Future<SharedPreferences> sharedPreferencesData;

  MainWidgetState(this.analytics,this.observer) {
    this.sharedPreferencesData = SharedPreferences.getInstance();
  }

  changePage(Screen screen, int i) {
    analytics.logEvent(name: "change_page",parameters: {"page_name":screen.getScreenName()});
    analytics.setCurrentScreen(screenName: screen.getScreenName());
    setState(() {
      _screen = screen;
      index = i;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    if (APIManager.login == null) {
      return FutureBuilder<SharedPreferences>(
          future: sharedPreferencesData,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data.getString("access_token") != null &&
                  snapshot.data.getString("token_type") != null) {
                APIManager.login = LoginResponse(
                    snapshot.data.getString("access_token"),
                    snapshot.data.getString("token_type"),
                    null);
              }
            }
            if (APIManager.login != null) {
              APIManager.getUser().then((user){
                analytics.setUserId(user.id.toString());
                analytics.setUserProperty(name: "user_name", value: user.name);
                analytics.setUserProperty(name: "user_created", value: user.created_at);
              });
              _screen = Home(this);
              return Scaffold(
                  appBar: AniflixAppbar(this, ctx),
                  body: _screen,
                  bottomNavigationBar: AniflixNavigationbar(this, index, ctx),
                  floatingActionButton: (index == 0)
                      ? FloatingActionButton(
                          backgroundColor: Theme.of(ctx).iconTheme.color,
                          onPressed: showChat,
                          child: Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                        )
                      : null);
            } else {
              return Scaffold(body: Login(this));
            }
          });
    } else {
      return Scaffold(
          appBar: AniflixAppbar(this, ctx),
          body: _screen,
          bottomNavigationBar: AniflixNavigationbar(this, index, ctx),
          floatingActionButton: (index == 0)
              ? FloatingActionButton(
                  backgroundColor: Theme.of(ctx).iconTheme.color,
                  onPressed: showChat,
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                )
              : null);
    }
  }

  showChat() {changePage(ChatScreen(this), 5);}
}
