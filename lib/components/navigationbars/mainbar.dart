import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import '../../main.dart';

class AniflixNavigationbar extends BottomNav {
  Function(AniflixNavState) _onCreated;

  AniflixNavigationbar(int index, this._onCreated, ThemeData theme)
      : super(
          index: index,
          items: getItems(),
          color: theme.bottomAppBarTheme.color,
          iconStyle: IconStyle(
              color: theme.primaryIconTheme.color,
              onSelectColor: theme.accentIconTheme.color),
          labelStyle: LabelStyle(
              textStyle: TextStyle(color: theme.primaryIconTheme.color),
              onSelectTextStyle: TextStyle(color: theme.accentIconTheme.color)),
        );

  static getItems() {
    return [
      BottomNavItem(Icons.home, label: 'Home'),
      BottomNavItem(Icons.subscriptions, label: 'Abos'),
      BottomNavItem(Icons.list, label: 'Alle'),
    ];
  }

  @override
  BottomNavState createState() {
    var state = AniflixNavState();
    _onCreated(state);
    return state;
  }
}

class AniflixNavState extends BottomNavState {
  int currentIndex;
  IconStyle iconStyle;
  LabelStyle labelStyle;

  updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

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
              selected: selected,
              icon: b.icon,
              iconSize:
                  selected ? iconStyle.getSelectedSize() : iconStyle.getSize(),
              label: parseLabel(b.label, labelStyle, selected),
              onTap: () {
                onItemClick(i);

                switch (i) {
                  case 0:
                    if(currentIndex != 0){
                    Navigator.pushNamed(context, "home");
                    }
                    break;
                  case 1:
                    if(currentIndex != 1){
                    Navigator.pushNamed(context, "subbox");
                    }
                    break;
                  case 2:
                    if(currentIndex != 2){
                    Navigator.pushNamed(context, "animelist");
                    }
                    break;
                  default:
                    break;
                }
              },
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
      AppState.setIndex(i);
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
  bool selected;

  AniflixNavItem(
      {IconData icon,
      double iconSize,
      String label,
      void Function() onTap,
      Color color,
      TextStyle textStyle,
      this.key,
      this.selected})
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
            Icon(icon,
                size: iconSize,
                color: (selected)
                    ? Theme.of(context).accentIconTheme.color
                    : Theme.of(context).primaryIconTheme.color),
            label != null
                ? Text(label,
                    style: TextStyle(
                        color: (selected)
                            ? Theme.of(context).accentIconTheme.color
                            : Theme.of(context).primaryIconTheme.color))
                : Container()
          ])),
      highlightColor: Theme.of(context).highlightColor,
      splashColor: Theme.of(context).splashColor,
      radius: Material.defaultSplashRadius,
      onTap: () => onTap(),
    ));
  }
}
