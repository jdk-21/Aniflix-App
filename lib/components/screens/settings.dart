import 'package:aniflix_app/components/custom/listelements/listElement.dart';
import 'package:aniflix_app/components/custom/dialogs/logoutDialog.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget implements Screen {
  Settings();

  @override
  getScreenName() {
    return "settings_screen";
  }

  @override
  Widget build(BuildContext ctx) {
    ThemeManager manager = ThemeManager.getInstance();
    return Container(
        key: Key("settings_screen"),
        color: Theme.of(ctx).backgroundColor,
        child: Column(
          children: <Widget>[
          (AppState.adFailed) ? Container() : SizedBox(height: 50,),
            Expanded(
              child: ListView(
                children: [
                  ListElement("Userlist", ctx, onTap: () {
                    Navigator.pushNamed(ctx, "userlist");
                  }, key: Key("Userlist")),
                  ListElement("Verlauf", ctx, onTap: () {
                    Navigator.pushNamed(ctx, "history");
                  }, key: Key("Verlauf")),
                  ListElement("Watchlist", ctx, onTap: () {
                    Navigator.pushNamed(ctx, "watchlist");
                  }, key: Key("Watchlist")),
                  ListElement("Favoriten", ctx, onTap: () {
                    Navigator.pushNamed(ctx, "favourites");
                  }, key: Key("Favoriten")),
                  ListElement("Theme", ctx,
                      onTap: () {},
                      child: Theme(
                          data: Theme.of(ctx).copyWith(
                              canvasColor: Theme.of(ctx).backgroundColor),
                          child: DropdownButton<int>(
                            key: Key("themes"),
                            style: TextStyle(
                                color: Theme.of(ctx).textTheme.caption.color,
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
                                  color: Theme.of(ctx).textTheme.caption.color),
                            ),
                          ))),
                  ListElement("Logout", ctx, onTap: () {
                    showDialog(
                        context: ctx,
                        builder: (BuildContext ctx) {
                          return LogoutDialog();
                        });
                  }),
                ],
              ),
            )
          ],
        ));
  }
}
