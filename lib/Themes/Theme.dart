import 'package:flutter/material.dart';

class CustomTheme {
  String ThemeName;
  Color mainbarColor;
  Color appbarColor;
  Color screenBackgroundColor;
  Color unselectedIconColor;
  Color selectedIconColor;
  Color textColor;

  CustomTheme(
      this.ThemeName,
      this.screenBackgroundColor,
      this.mainbarColor,
      this.appbarColor,
      this.unselectedIconColor,
      this.selectedIconColor,
      this.textColor);

  String getThemeName() {
    return ThemeName;
  }

  Color getMainbarColor() {
    return mainbarColor;
  }

  Color getAppbarColor() {
    return appbarColor;
  }

  Color getScreenBackgroundColor() {
    return screenBackgroundColor;
  }

  Color getUnselectedIconColor() {
    return unselectedIconColor;
  }

  Color getSelectedIconColor() {
    return selectedIconColor;
  }

  Color getTextColor() {
    return textColor;
  }

  ThemeData getThemeData(){
    return new ThemeData(
      textTheme: TextTheme(title: TextStyle(color: this.textColor)),
      appBarTheme: AppBarTheme(color: this.appbarColor),
      bottomAppBarTheme: BottomAppBarTheme(color: this.mainbarColor),
      backgroundColor: this.screenBackgroundColor,
      primaryIconTheme: IconThemeData(color: this.selectedIconColor),
      accentIconTheme: IconThemeData(color: this.unselectedIconColor),
    );
  }
}
