import 'package:aniflix_app/Themes/Theme.dart';
import 'package:aniflix_app/Themes/ThemeManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';

void main() {
  ThemeManager manager = ThemeManager.getInstance();
  manager.addNewTheme(new CustomTheme("Dark Theme", Color.fromRGBO(15, 15, 19, 1),
      Colors.black, Colors.black, Colors.white, Colors.white, Colors.white));
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
  changePage(int i){
    setState(() {
        index = i;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var bar = AniflixNavigationbar(this, index, ctx);

    return Scaffold(
      appBar: AniflixAppbar(ctx),
      body: PageStorage(child: AniflixNavigationbar.currentScreen, bucket: bucket),
      bottomNavigationBar: bar,
      floatingActionButton: (index == 0)? FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: showChat,
        child: Icon(Icons.chat),
      ) : null,
    );
  }
  showChat(){

  }
}