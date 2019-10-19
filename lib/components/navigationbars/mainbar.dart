import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../screens/home.dart';
import '../screens/subbox.dart';
import '../screens/animelist.dart';
import '../../main.dart';

class Aniflixbar {
  int currentTab;
  Widget currentScreen;
  BottomNav nav;

  Aniflixbar(MainWidgetState state, int index){
    currentTab = index;
    currentScreen = getScreens()[index];
    nav = BottomNav(
      index: currentTab,
      onTap: (i) {
        state.changePage(i);
      },
      items: getItems(),
      color: Colors.black,
      iconStyle: IconStyle(color: Colors.white, onSelectColor: Colors.red),
      labelStyle: LabelStyle(textStyle: TextStyle(color: Colors.white)),
    );
  }

  getNavBar(){
    return nav;
  }

  getScreens(){
    return [
      Home(),
      SubBox(),
      AnimeList()
    ];
  }

  getItems(){
    return [
      BottomNavItem(Icons.home, label: 'Home'),
      BottomNavItem(Icons.subscriptions, label: 'Abos'),
      BottomNavItem(Icons.list, label: 'Alle'),
    ];
  }
}
