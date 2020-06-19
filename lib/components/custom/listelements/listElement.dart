import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class ListElement extends Container {
  ListElement(String title, BuildContext ctx,
      {Function onTap, Widget child, Key key})
      : super(
            key: key,
            child: FlatButton(
              onPressed: onTap,
              padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
              child: (child == null)
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: ThemeText(title,
                          fontSize: 35, fontWeight: FontWeight.normal))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          ThemeText(title,
                              fontSize: 35, fontWeight: FontWeight.normal),
                          child
                        ]),
              color: Theme.of(ctx).backgroundColor,
            ));
}
