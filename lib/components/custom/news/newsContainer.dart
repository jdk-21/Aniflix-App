import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class NewsContainer extends Container {
  NewsContainer(String text, BuildContext ctx)
      : super(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(ctx).hintColor,
                      style: BorderStyle.solid))),
          child: ThemeText(
            text,
            ctx,
            softWrap: true,
          )
        );
}
