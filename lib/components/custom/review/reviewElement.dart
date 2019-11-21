import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReviewElement extends Container {
  Review review;
  BuildContext ctx;

  ReviewElement(this.review, this.ctx)
      : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              "https://www2.aniflix.tv/storage/" +
                                  review.user.avatar,
                            ),
                          ))),
                  Text(
                    review.user.name,
                    style:
                        TextStyle(color: Theme.of(ctx).textTheme.title.color),
                    softWrap: true,
                  )
                ],
              ),
              Expanded(
                child: Text(
                  review.text,
                  style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
                  softWrap: true,
                ),
              ),
              Text(
                review.vote.value == null
                    ? ""
                    : review.vote.value.toString() + "/5",
                style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
                softWrap: true,
              )
            ],
          ),
        );
}
