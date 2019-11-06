import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './profil.dart';
import './verlauf.dart';
import './watchlist.dart';
import './favoriten.dart';
import './login.dart';

class Settings extends StatelessWidget {
  MainWidgetState state;

  Settings(this.state);

  @override
  Widget build(BuildContext ctx) {
    ThemeManager manager = ThemeManager.getInstance();
    return Container(
      color: Theme.of(ctx).backgroundColor,
      child: ListView(
        children: [
          FlatButton(
            onPressed: () {
              state.changePage(Profil(), 6);
            },
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Profil",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 35,
                        fontWeight: FontWeight.normal))),
            color: Theme.of(ctx).backgroundColor,
          ),
          FlatButton(
            onPressed: () {
              state.changePage(Verlauf(), 7);
            },
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Verlauf",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 35,
                        fontWeight: FontWeight.normal))),
            color: Theme.of(ctx).backgroundColor,
          ),
          FlatButton(
            onPressed: () {
              state.changePage(Watchlist(), 8);
            },
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Watchlist",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 35,
                        fontWeight: FontWeight.normal))),
            color: Theme.of(ctx).backgroundColor,
          ),
          FlatButton(
            onPressed: () {
              state.changePage(Favoriten(), 9);
            },
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Favoriten",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 35,
                        fontWeight: FontWeight.normal))),
            color: Theme.of(ctx).backgroundColor,
          ),
          Container(
              padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
              color: Theme.of(ctx).backgroundColor,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Theme",
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.title.color,
                            fontSize: 35,
                            fontWeight: FontWeight.normal)),
                    Theme(
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
                        ))
                  ])),
          FlatButton(
            onPressed: () {
              showDialog(
                  context: ctx,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      backgroundColor: Theme.of(ctx).backgroundColor,
                      contentTextStyle: TextStyle(color: Theme.of(ctx).textTheme.title.color),
                      content: Text("Wirklich ausloggen?"),
                      actions: <Widget>[
                        FlatButton(
                          color: Colors.red,
                          child: Text("Abbrechen", style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        FlatButton(
                          color: Colors.green,
                          child: Text("Ausloggen", style: TextStyle(color: Colors.white),),
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove("access_token");
                            prefs.remove("token_type");
                            APIManager.login = null;
                            state.changePage(Login(state), 0);
                          },
                        )
                      ],
                    );
                  });
            },
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Logout",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.title.color,
                        fontSize: 35,
                        fontWeight: FontWeight.normal))),
            color: Theme.of(ctx).backgroundColor,
          ),
        ],
      ),
    );
  }
}
