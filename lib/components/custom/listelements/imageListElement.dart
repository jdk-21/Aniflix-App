import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/images/aniflixImage.dart';

class ImageListElement extends Container {
  ImageListElement(
    String title,
    String image,
    BuildContext ctx, {
    Function onTap,
    String descLine1,
    String descLine2,
    String descLine3,
  }) : super(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        width: 1,
                        color: Theme.of(ctx).hintColor,
                        style: BorderStyle.solid))),
            child: FlatButton(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
              onPressed: onTap,
              child: Row(children: <Widget>[
                AniflixImage(
                  image,
                  width: 50,
                  height: 75,
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ThemeText(
                          title,
                          ctx,
                          softWrap: true,
                        )),
                    (descLine1 != null)
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: ThemeText(descLine1, ctx,
                                fontSize: 15, softWrap: true,maxLines: 5,))
                        : Container(),
                    (descLine2 != null)
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: ThemeText(
                              descLine2,
                              ctx,
                              fontSize: 15,
                              softWrap: true,
                            ))
                        : Container(),
                    (descLine3 != null)
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: ThemeText(
                              descLine3,
                              ctx,
                              fontSize: 15,
                              softWrap: true,
                            ))
                        : Container()
                  ],
                )),
              ]),
            ));
}
