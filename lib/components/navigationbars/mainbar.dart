import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/profil.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../screens/home.dart';
import '../screens/subbox.dart';
import '../screens/animelist.dart';
import '../screens/settings.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../../main.dart';

class ScreenManager {
  static ScreenManager instance;
  int _currentTab;
  MainWidgetState _state;

  ScreenManager(MainWidgetState state) {
    _currentTab = 0;
    _state = state;
  }


  getScreens() {
    return [Home(), SubBox(), AnimeList(), Settings(_state), Login(_state), Register(_state), Profil(), Verlauf(), Watchlist(), Favoriten()];
  }

  setCurrentTab(int i) {
    this._currentTab = i;
  }

  getCurrentScreen() {
    return getScreens()[_currentTab];
  }

  static ScreenManager getInstance(MainWidgetState state) {
    if (instance == null) {
      instance = ScreenManager(state);
    }
    return instance;
  }
}

class AniflixNavigationbar extends BottomNav {
  AniflixNavigationbar(MainWidgetState state, int index, BuildContext ctx)
      : super(
          index: index,
          onTap: (i) {
            state.changePage(i);
            ScreenManager.getInstance(state).setCurrentTab(i);
          },
          items: getItems(),
          color: Theme.of(ctx).bottomAppBarTheme.color,
          iconStyle: IconStyle(
              color: Theme.of(ctx).primaryIconTheme.color,
              onSelectColor: Theme.of(ctx).accentIconTheme.color),
          labelStyle: LabelStyle(
              textStyle: TextStyle(color: Theme.of(ctx).primaryIconTheme.color),
              onSelectTextStyle:
                  TextStyle(color: Theme.of(ctx).accentIconTheme.color)),
        );

  static getItems() {
    return [
      BottomNavItem(Icons.home, label: 'Home'),
      BottomNavItem(Icons.subscriptions, label: 'Abos'),
      BottomNavItem(Icons.list, label: 'Alle'),
    ];
  }
  
  @override
  BottomNavState createState() => AniflixNavState();
}

class AniflixNavState extends BottomNavState {
  int currentIndex;
  IconStyle iconStyle;
  LabelStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: widget.elevation,
        color: widget.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: widget.items.map((b) {
            final int i = widget.items.indexOf(b);
            final bool selected = i == currentIndex;

            return AniflixNavItem(
              key: ValueKey(b.label),
              icon: b.icon,
              iconSize:
                  selected ? iconStyle.getSelectedSize() : iconStyle.getSize(),
              label: parseLabel(b.label, labelStyle, selected),
              onTap: () => onItemClick(i),
              textStyle: selected
                  ? labelStyle.getOnSelectTextStyle()
                  : labelStyle.getTextStyle(),
              color: selected
                  ? iconStyle.getSelectedColor()
                  : iconStyle.getColor(),
            );
          }).toList(),
        ));
  }

  onItemClick(int i) {
    setState(() {
      currentIndex = i;
    });
    if (widget.onTap != null) widget.onTap(i);
  }

  parseLabel(String label, LabelStyle style, bool selected) {
    if (!style.isVisible()) {
      return null;
    }

    if (style.isShowOnSelect()) {
      return selected ? label : null;
    }

    return label;
  }
}

class AniflixNavItem extends BMNavItem {
  Key key;

  AniflixNavItem(
      {IconData icon,
      double iconSize,
      String label,
      void Function() onTap,
      Color color,
      TextStyle textStyle,
      this.key})
      : super(
            icon: icon,
            iconSize: iconSize,
            label: label,
            onTap: onTap,
            color: color,
            textStyle: textStyle);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkResponse(
      child: Padding(
          padding: getPadding(),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Icon(icon, size: iconSize, color: color),
            label != null ? Text(label, style: textStyle) : Container()
          ])),
      highlightColor: Theme.of(context).highlightColor,
      splashColor: Theme.of(context).splashColor,
      radius: Material.defaultSplashRadius,
      onTap: () => onTap(),
    ));
  }
}
