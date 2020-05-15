import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/Themes/theme.dart';

class ThemeManager {
  static ThemeManager instance;
  List<CustomTheme> Themes = new List<CustomTheme>();
  CustomTheme actualTheme;
  int actualThemeIndex;

  ThemeManager();

  static ThemeManager getInstance() {
    if (instance == null) {
      instance = ThemeManager();
      instance.addNewThemes([
        CustomTheme(
            themeName: "Dark Theme",
            screenBackgroundColor: Color.fromRGBO(15, 15, 15, 1),
            mainbarColor: Colors.black,
            appbarColor: Colors.black,
            unselectedIconColor: Colors.white,
            selectedIconColor: Colors.red,
            chatButtonColor: Colors.red,
            textColor: Colors.white),
        CustomTheme(
            themeName: "Light Theme",
            screenBackgroundColor: Colors.white,
            mainbarColor: Colors.white,
            appbarColor: Colors.white,
            unselectedIconColor: Colors.black,
            selectedIconColor: Colors.red,
            textColor: Colors.black,
            chatButtonColor: Colors.red),
        CustomTheme(
            themeName: "Blue Dark Theme",
            screenBackgroundColor: Colors.black,
            mainbarColor: Colors.black,
            appbarColor: Colors.black,
            unselectedIconColor: Color.fromRGBO(0, 150, 255, 1),
            selectedIconColor: Color.fromRGBO(200, 0, 200, 1),
            textColor: Color.fromRGBO(0, 150, 255, 1),
            chatButtonColor: Color.fromRGBO(0, 150, 255, 1)),
        CustomTheme(
            themeName: "Red Dark Theme",
            screenBackgroundColor: Colors.black,
            mainbarColor: Colors.black,
            appbarColor: Colors.black,
            unselectedIconColor: Colors.orange,
            selectedIconColor: Colors.red,
            textColor: Colors.red,
            chatButtonColor: Colors.red)
      ]);
      instance.setActualTheme(0);
    }
    return instance;
  }

  List<DropdownMenuItem<int>> getThemeNames() {
    List<DropdownMenuItem<int>> namelist = [];
    for (int l = 0; l < Themes.length; l++) {
      namelist.add(DropdownMenuItem(
        key: Key(Themes.elementAt(l).themeName),
          value: l, child: Text(Themes.elementAt(l).themeName)));
    }
    return namelist;
  }

  void setActualTheme(int index) {
    this.actualTheme = Themes.elementAt(index);
    this.actualThemeIndex = index;
  }

  void addNewTheme(CustomTheme i) {
    this.Themes.add(i);
  }

  void addNewThemes(List<CustomTheme> i) {
    for (int x = 0; x < i.length; x++) {
      this.Themes.add(i.elementAt(x));
    }
  }

  ThemeData getActualThemeData() {
    return actualTheme.getThemeData();
  }
}
