import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../screens/home.dart';
import '../screens/subbox.dart';
import '../screens/animelist.dart';
import '../../main.dart';

class AniflixNavigationbar extends BottomNav{
  static int currentTab = 0;
  static Widget currentScreen = getScreens()[0];

  AniflixNavigationbar(MainWidgetState state, int index, BuildContext ctx):super(index: index,
    onTap: (i) {
      state.changePage(i);
    },
    items: getItems(),
    color: Theme.of(ctx).bottomAppBarTheme.color,
    iconStyle: IconStyle(color: Theme.of(ctx).primaryIconTheme.color, onSelectColor: Theme.of(ctx).accentIconTheme.color),
    labelStyle: LabelStyle(textStyle: TextStyle(color: Theme.of(ctx).primaryIconTheme.color),onSelectTextStyle: TextStyle(color: Theme.of(ctx).accentIconTheme.color)),){
    currentTab = index;
    currentScreen = getScreens()[currentTab];
  }

  static getScreens(){
    return [
      Home(),
      SubBox(),
      AnimeList()
    ];
  }

  static getItems(){
    return [
      BottomNavItem(Icons.home, label: 'Home'),
      BottomNavItem(Icons.subscriptions, label: 'Abos'),
      BottomNavItem(Icons.list, label: 'Alle'),
    ];
  }
}
