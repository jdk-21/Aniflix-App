import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class AniflixNavigationbar extends TitledBottomNavigationBar {
  AniflixNavigationbar(
      int index, PageController controller, BuildContext context)
      : super(
          onTap: (i) {
            AppState.setIndex(i);
            controller.jumpToPage(i);
          },
          currentIndex: index,
          items: getItems(Theme.of(context)),
          activeColor: Theme.of(context).iconTheme.color,
        );

  static getItems(ThemeData theme) {
    return [
      TitledNavigationBarItem(
          icon: Icons.home,
          title: ThemeText('Home'),
          backgroundColor: theme.backgroundColor),
      TitledNavigationBarItem(
          icon: Icons.subscriptions,
          title: ThemeText('Abos'),
          backgroundColor: theme.backgroundColor),
      TitledNavigationBarItem(
          icon: Icons.list,
          title: ThemeText('Alle'),
          backgroundColor: theme.backgroundColor),
    ];
  }
}
