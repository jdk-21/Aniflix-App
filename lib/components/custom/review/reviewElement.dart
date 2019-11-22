import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                child: Column(
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
                    Text(
                      review.user.name,
                      style:
                          TextStyle(color: Theme.of(ctx).textTheme.title.color),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 300,
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        review.text,
                        style: TextStyle(
                            color: Theme.of(ctx).textTheme.title.color),
                        softWrap: true,
                      );
                    }),
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
