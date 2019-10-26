import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './components/appbars/customappbar.dart';
import './components/navigationbars/mainbar.dart';

void main() {
  runApp(MaterialApp(
    title: 'Aniflix App',
    home: MainWidget(),
    theme: ThemeData(primaryColor: Colors.black),
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
    return Scaffold(
      appBar: AniflixAppbar(),
      body: ScreenManager.getInstance().getCurrentScreen(),
      bottomNavigationBar: AniflixNavigationbar(this, index),
      floatingActionButton: (index == 0)
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: showChat,
              child: Icon(Icons.chat),
            )
          : null,
    );
  }

  showChat() {}
}
