import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../screens/home.dart';
import '../screens/subbox.dart';
import '../screens/animelist.dart';
import '../../main.dart';

class AniflixNavigationbar extends BottomNav{
  static int currentTab = 0;
  static Widget currentScreen = getScreens()[0];

  AniflixNavigationbar(MainWidgetState state, int index):super(index: index,
    onTap: (i) {
      state.changePage(i);
    },
    items: getItems(),
    color: Colors.black,
    iconStyle: IconStyle(color: Colors.white, onSelectColor: Colors.red),
    labelStyle: LabelStyle(textStyle: TextStyle(color: Colors.white)),){
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
