import 'package:aniflix_app/components/custom/listelements/listElement.dart';
import 'package:aniflix_app/components/custom/dialogs/logoutDialog.dart';
import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './profil.dart';
import './verlauf.dart';
import './watchlist.dart';
import './favoriten.dart';


class Settings extends StatelessWidget {
  MainWidgetState state;

  Settings(this.state);

  @override
  Widget build(BuildContext ctx) {
    ThemeManager manager = ThemeManager.getInstance();
    return Container(
      key: Key("settings_screen"),
      color: Theme.of(ctx).backgroundColor,
      child: ListView(
        children: [
          ListElement("Profil",ctx,onTap: () {
            state.changePage(Profil(), 6);
          }),
          ListElement("Verlauf",ctx,onTap: () {
            state.changePage(Verlauf(state), 7);
          }),
          ListElement("Watchlist",ctx,onTap: () {
            state.changePage(Watchlist(state), 8);
          }),
          ListElement("Favoriten",ctx,onTap: () {
            state.changePage(Favoriten(state), 9);
          }),
          ListElement("Theme",ctx,onTap: () {},
            child:Theme(
                data: Theme.of(ctx).copyWith(
                    canvasColor: Theme.of(ctx).backgroundColor),
                child: DropdownButton<int>(
                  style: TextStyle(
                      color: Theme.of(ctx).textTheme.title.color,
                      fontSize: 20),
                  items: manager.getThemeNames(),
                  onChanged: (newValue) async {
                    App.setTheme(ctx, newValue);
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.setInt(
                        "actualTheme", manager.actualThemeIndex);
                  },
                  value: manager.actualThemeIndex,
                  hint: Text(
                    manager.actualTheme.getThemeName(),
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color),
                  ),
                ))),
          ListElement("Logout",ctx,onTap: () {
            showDialog(
                context: ctx,
                builder: (BuildContext ctx) {
                  return LogoutDialog(state);
                });
          }),
        ],
      ),
    );
  }
}
