import 'package:flutter/material.dart';
import 'package:aniflix_app/Themes/Theme.dart';

class ThemeManager {
  static ThemeManager instance;
  List<CustomTheme> Themes = new List<CustomTheme>();
  CustomTheme actualTheme;

  ThemeManager();

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
