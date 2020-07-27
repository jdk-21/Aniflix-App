import 'package:aniflix_app/components/screens/animelist.dart';
import 'package:aniflix_app/components/screens/home.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/components/screens/subbox.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';

class HomeViewSlider extends StatelessWidget implements Screen{
  PageController _controller;

  HomeViewSlider(this._controller);

  @override
  getScreenName() {
    return "HomeViewSlider";
  }

  @override
  Widget build(BuildContext context) {
    return PageView( controller: _controller, children: [Home(), SubBox(), AnimeList()], onPageChanged:(value) => AppState.setIndex(value));
  }
}
