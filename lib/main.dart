import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
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
  changePage(int i){
    setState(() {
        index = i;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var bar = Aniflixbar(this, index);

    return Scaffold(
      appBar: AppBar(title: Text('Aniflix'),),
      body: PageStorage(child: bar.currentScreen, bucket: bucket),
      bottomNavigationBar: bar.getNavBar()
    );
  }
}