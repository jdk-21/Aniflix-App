import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../screens/home.dart';
import '../screens/subbox.dart';
import '../screens/animelist.dart';
import '../../main.dart';

class ScreenManager {
  static ScreenManager instance;
  int _currentTab;
  List<Widget> _screens;

  ScreenManager() {
    _currentTab = 0;
    _screens = [Home(), SubBox(), AnimeList()];
  }

  getScreens() {
    return _screens;
  }

  setCurrentTab(int i) {
    this._currentTab = i;
  }

  getCurrentScreen() {
    return getScreens()[_currentTab];
    ;
  }

  static ScreenManager getInstance() {
    if (instance == null) {
      instance = ScreenManager();
    }
    return instance;
  }
}

class AniflixNavigationbar extends BottomNav {
  AniflixNavigationbar(MainWidgetState state, int index, BuildContext ctx)
      : super(
          index: index,
          onTap: (i) {
            state.changePage(i);
            ScreenManager.getInstance().setCurrentTab(i);
          },
          color: Theme.of(ctx).bottomAppBarTheme.color,
          iconStyle: IconStyle(
              color: Theme.of(ctx).primaryIconTheme.color,
              onSelectColor: Theme.of(ctx).accentIconTheme.color),
          labelStyle: LabelStyle(
              textStyle: TextStyle(color: Theme.of(ctx).primaryIconTheme.color),
              onSelectTextStyle:
                  TextStyle(color: Theme.of(ctx).accentIconTheme.color)),
        );

  static getItems() {
    return [
      BottomNavItem(Icons.home, label: 'Home'),
      BottomNavItem(Icons.subscriptions, label: 'Abos'),
      BottomNavItem(Icons.list, label: 'Alle'),
    ];
  }
}
