import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/images/ProfileImage.dart';

class IconListElement extends Container {
  IconListElement(
    String title,
    String icon,
    BuildContext ctx, {
    Function onTap,
    Widget button,
  }) : super(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        width: 1,
                        color: Theme.of(ctx).hintColor,
                        style: BorderStyle.solid))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  onPressed: onTap,
                  child: Row(children: <Widget>[
                    ProfileImage(icon, () {}),
                    SizedBox(width: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ThemeText(
                          title,
                          softWrap: true,
                        )),
                  ]),
                ),
                (button == null) ? Container() : button,
              ],
            ));
}
