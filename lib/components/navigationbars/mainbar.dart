
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../screens/home.dart';
import '../screens/subbox.dart';
import '../screens/animelist.dart';
import '../../main.dart';

class ScreenManager {
  static ScreenManager instance;
  int currentTab;
  Widget currentScreen;
  List<Widget> screens;

  ScreenManager() {
    currentTab = 0;
    screens = [
      Home(),
      SubBox(),
      AnimeList()
    ];
    currentScreen = getScreens()[currentTab];
  }

  getScreens() {
    return screens;
  }

  static ScreenManager getInstance() {
    if (instance == null) {
      instance = ScreenManager();
    }
    return instance;
  }
}

class AniflixNavigationbar extends BottomNav {
  AniflixNavigationbar(MainWidgetState state, int index)
      : super(
          index: index,
          onTap: (i) {
            state.changePage(i);
          },
          items: getItems(),
          color: Colors.black,
          iconStyle: IconStyle(color: Colors.white, onSelectColor: Colors.red),
          labelStyle: LabelStyle(textStyle: TextStyle(color: Colors.white)),
        );

  static getItems() {
    return [
      BottomNavItem(Icons.home, label: 'Home'),
      BottomNavItem(Icons.subscriptions, label: 'Abos'),
      BottomNavItem(Icons.list, label: 'Alle'),
    ];
  }
}
