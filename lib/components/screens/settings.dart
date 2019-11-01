import 'package:aniflix_app/themes/themeManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/navigationbars/mainbar.dart';

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
            onPressed: () {},
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
            onPressed: () {},
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
            onPressed: () {},
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
            onPressed: () {},
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
                          style: TextStyle(color: Theme.of(ctx).textTheme.title.color,fontSize: 20),
                          items: manager.getThemeNames(),
                          onChanged: (newValue) {},
                          value: manager.actualThemeIndex,
                          hint: Text(manager.actualTheme.getThemeName(), style: TextStyle(color: Theme.of(ctx).textTheme.title.color),),
                        ))
                  ])),
          FlatButton(
            onPressed: () {
              state.changePage(4);
              ScreenManager.getInstance(state).setCurrentTab(4);
            },
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Login/Logout",
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
