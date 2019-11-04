import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';

void main() {
  ThemeManager manager = ThemeManager.getInstance();
  manager.setActualTheme(0);
  runApp(MaterialApp(
    title: 'Aniflix App',
    home: MainWidget(),
    theme: manager.getActualThemeData(),
  ));
}

class MainWidget extends StatefulWidget {
  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  final PageStorageBucket bucket = PageStorageBucket();
  int index = 0;

  changePage(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var bar = AniflixNavigationbar(this, index, ctx);
    if(APIManager.login != null){
      return Scaffold(
          appBar: AniflixAppbar(this, ctx),
          body: ScreenManager.getInstance(this).getCurrentScreen(),
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
      return Scaffold(body: ScreenManager.getInstance(this).getScreens()[4]);
    }

  }

  showChat() {}
}
