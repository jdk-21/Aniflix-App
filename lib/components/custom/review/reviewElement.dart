import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class ReviewElement extends Container {
  Review review;
  BuildContext ctx;

  ReviewElement(this.review, this.ctx)
      : super(
          padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Theme.of(ctx).hintColor,
                      style: BorderStyle.solid))),
          child: ExpandablePanel(
            tapBodyToCollapse: true,
            tapHeaderToExpand: true,
            header: Row( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (review.user.avatar == null)
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person,
                          color: Theme.of(ctx).primaryIconTheme.color,
                        ),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: new Container(
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    "https://www2.aniflix.tv/storage/" +
                                        review.user.avatar,
                                  ),
                                ))),
                      ),
                ThemeText(
                  review.user.name,
                  ctx,
                  softWrap: true,
                ),
                SizedBox(width: 10,),
                ThemeText(
                  review.vote == null || review.vote.value == null
                      ? ""
                      : review.vote.value.toString() + "/5",
                  ctx,
                  softWrap: true,
                )
              ],
            ),
            collapsed: Text(
              review.text,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
              softWrap: true,
            ),
            expanded: ThemeText(
              review.text,
              ctx,
              softWrap: true,
            ),
          ),
        );
}