import 'package:aniflix_app/api/objects/LoginResponse.dart';
import 'package:aniflix_app/components/screens/chat.dart';
import 'package:aniflix_app/components/screens/home.dart';
import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';
import './components/screens/login.dart';

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
    var manager = ThemeManager.getInstance();
    manager.setActualTheme(i);
    state.setState(() {
      state._theme = manager.getActualThemeData();
    });
  }
}

class _AppState extends State<App> {
  ThemeData _theme = ThemeManager.getInstance().getActualThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aniflix App',
      home: MainWidget(),
      theme: _theme,
    );
  }
}

class MainWidget extends StatefulWidget {
  static MainWidgetState of (BuildContext ctx) => ctx.ancestorStateOfType(const TypeMatcher<MainWidgetState>());
  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  final PageStorageBucket bucket = PageStorageBucket();
  Widget _screen;
  int index;

  Future<SharedPreferences> sharedPreferencesData;

  MainWidgetState() {
    this.sharedPreferencesData = SharedPreferences.getInstance();
  }

  changePage(Widget screen, int i) {
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
