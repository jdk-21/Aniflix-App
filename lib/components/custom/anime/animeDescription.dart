import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:expandable/expandable.dart';

class AnimeDescription extends Container {
  AnimeDescription(String description, BuildContext ctx)
      : super(
          child: ExpandablePanel(
            header: Align(
                alignment: Alignment.centerLeft,
                child: ThemeText("Beschreibung", ctx,
                    fontWeight: FontWeight.bold)),
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            collapsed: ThemeText(description, ctx, maxLines: 5, fontSize: 15,softWrap: true),
            expanded: Align(
                alignment: Alignment.centerLeft,
                child: ThemeText(
                  description,
                  ctx,
                  fontSize: 15,
                  softWrap: true,
                )),
            tapHeaderToExpand: true,
            hasIcon: true,
            iconColor: Theme.of(ctx).primaryIconTheme.color,
            tapBodyToCollapse: true,
          ),
        );
}
