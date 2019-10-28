import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  String themeName;
  Color mainbarColor;
  Color appbarColor;
  Color screenBackgroundColor;
  Color unselectedIconColor;
  Color selectedIconColor;
  Color chatButtonColor;
  Color textColor;

  CustomTheme(
      {this.themeName,
      this.screenBackgroundColor,
      this.mainbarColor,
      this.appbarColor,
      this.unselectedIconColor,
      this.selectedIconColor,
      this.chatButtonColor,
      this.textColor});

  String getThemeName() {
    return themeName;
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

  Color getChatButtonColor() {
    return this.chatButtonColor;
  }

  Color getTextColor() {
    return textColor;
  }

  ThemeData getThemeData() {
    return new ThemeData(
        textTheme: TextTheme(title: TextStyle(color: this.textColor)),
        appBarTheme: AppBarTheme(color: this.appbarColor),
        bottomAppBarTheme: BottomAppBarTheme(color: this.mainbarColor),
        backgroundColor: this.screenBackgroundColor,
        accentIconTheme: IconThemeData(color: this.selectedIconColor),
        primaryIconTheme: IconThemeData(color: this.unselectedIconColor),
        iconTheme: IconThemeData(color: this.chatButtonColor));
  }
}
