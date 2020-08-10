import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/profil.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class AniflixProfilebar extends TitledBottomNavigationBar {
  List<TitledNavigationBarItem> items = [];

  AniflixProfilebar(int index, PageController controller, this.items,
      BuildContext context, ProfileState state)
      : super(
          onTap: (i) {
            state.setIndex(i);
            controller.jumpToPage(i + 1);
          },
          currentIndex: index - 1,
          items: items,
          activeColor: Theme.of(context).iconTheme.color,
        );
}
