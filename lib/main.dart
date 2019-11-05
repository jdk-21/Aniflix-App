import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';
import './components/screens/login.dart';

void main() {
  ThemeManager manager = ThemeManager.getInstance();
  manager.setActualTheme(0);
  runApp(App());
}


class App extends StatefulWidget {
  App({Key key,}) :

        super(key: key);

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
  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  final PageStorageBucket bucket = PageStorageBucket();
  StatelessWidget _screen;
  int index;

  changePage(StatelessWidget screen, int i) {
    setState(() {
      _screen = screen;
      index = i;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var bar = AniflixNavigationbar(this, index, ctx);
    if(APIManager.login != null){
      return Scaffold(
          appBar: AniflixAppbar(this, ctx),
          body: _screen,
          bottomNavigationBar: AniflixNavigationbar(this, index,ctx),
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
    }else{
      return Scaffold(body: Login(this));
    }

  }

  showChat() {}
}
