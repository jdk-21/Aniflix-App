import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

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
                    (icon == null)
                        ? IconButton(
                            key: Key("Settings"),
                            icon: Icon(
                              Icons.person,
                              color: Theme.of(ctx).primaryIconTheme.color,
                            ),
                            onPressed: () {onTap();},
                          )
                        : IconButton(
                            key: Key("Settings"),
                            icon: new Container(
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        "https://www2.aniflix.tv/storage/" +
                                            icon,
                                      ),
                                    ))),
                            onPressed: () {onTap();}),
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
