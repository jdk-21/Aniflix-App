import 'package:flutter/material.dart';
import 'package:aniflix_app/Themes/Theme.dart';

class ThemeManager {
  static ThemeManager instance;
  List<CustomTheme> Themes;
  CustomTheme actualTheme;

  ThemeManager() {
    addNewTheme(new CustomTheme("Dark Theme", Color.fromRGBO(200, 15, 19, 1),
        Colors.yellow, Colors.yellow, Colors.blue, Colors.green, Colors.blue));
    setActualTheme(0);
  }

  static getInstance(){
    if(instance == null){
        instance = ThemeManager();
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

  ThemeData getActualThemeData(){
    return actualTheme.getThemeData();
  }
}
