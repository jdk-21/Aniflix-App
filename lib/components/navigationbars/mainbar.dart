import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/profil.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';
import 'package:aniflix_app/api/objects/LoginResponse.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../screens/home.dart';
import '../screens/subbox.dart';
import '../screens/animelist.dart';
import '../screens/settings.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../../main.dart';

class ScreenManager {
  static ScreenManager instance;
  int _currentTab;
  MainWidgetState _state;

  ScreenManager(MainWidgetState state) {
    _currentTab = 0;
    _state = state;
  }


  getScreens() {
    return [Home(), SubBox(), AnimeList(), Settings(_state), Login(_state), Register(_state), Profil(), Verlauf(), Watchlist(), Favoriten()];
  }

  setCurrentTab(int i) {
    this._currentTab = i;
  }

  getCurrentScreen() {
    return getScreens()[_currentTab];
  }

  static ScreenManager getInstance(MainWidgetState state) {
    if (instance == null) {
      instance = ScreenManager(state);
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
            ScreenManager.getInstance(state).setCurrentTab(i);
          },
          items: getItems(),
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
