import 'package:aniflix_app/Themes/Theme%20Manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';

void main() {
  ThemeManager manager = ThemeManager.getInstance();
  runApp(MaterialApp(
    title: 'Aniflix App',
    home: MainWidget(),
    theme: new ThemeManager().getActualThemeData(),
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
      appBar: AniflixAppbar(),
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