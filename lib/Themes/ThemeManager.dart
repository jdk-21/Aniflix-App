import 'package:flutter/material.dart';
import 'package:aniflix_app/Themes/Theme.dart';

class ThemeManager {
  static ThemeManager instance;
  List<CustomTheme> Themes = new List<CustomTheme>();
  CustomTheme actualTheme;

  ThemeManager();

  static getInstance() {
    if (instance == null) {
      instance = ThemeManager();
      instance.addNewThemes([
        CustomTheme(
            themeName: "Dark Theme",
            screenBackgroundColor: Color.fromRGBO(15, 15, 19, 1),
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
            chatButtonColor: Color.fromRGBO(0, 150, 255, 1))
      ]);
    }
    return instance;
  }

  void setActualTheme(int index) {
    this.actualTheme = Themes.elementAt(index);
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
