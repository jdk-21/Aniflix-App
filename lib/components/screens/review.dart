import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:aniflix_app/components/custom/review/reviewElement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReviewScreen extends StatefulWidget {
  String url;

  ReviewScreen(this.url);

  @override
  ReviewScreenState createState() => ReviewScreenState(url);
}

class ReviewScreenState extends State<ReviewScreen> {
  Future<ReviewInfo> reviewData;
  String url;
  List<ReviewElement> _actualReviews = [];

  addNewReview(Review review, BuildContext ctx) {
    _actualReviews.add(ReviewElement(review, ctx));
  }

  ReviewScreenState(this.url) {
    reviewData = APIManager.getReviewInfo(url);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("home_screen"),
      child: FutureBuilder<ReviewInfo>(
        future: reviewData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var reviewedAnime = snapshot.data.reviewShow;
            if (_actualReviews.length < 1) {
              for (var review in reviewedAnime.reviews) {
                _actualReviews.add(ReviewElement(review, ctx));
              }
            }
            return Container(
              color: Theme.of(ctx).backgroundColor,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Reviews zu",
                          style: TextStyle(
                              color: Theme.of(ctx).textTheme.title.color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          reviewedAnime.name,
                          style: TextStyle(
                              color: Theme.of(ctx).textTheme.title.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(children: _actualReviews),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1,
                                color: Theme.of(ctx).hintColor,
                                style: BorderStyle.solid))),
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: OutlineButton(
                        textColor: Theme.of(ctx).textTheme.title.color,
                        borderSide: BorderSide(
                            color: Theme.of(ctx).textTheme.title.color),
                        child: Text("Review schreiben"),
                        onPressed: () {
                          showDialog(
                              context: ctx,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(ctx).backgroundColor,
                                  contentTextStyle: TextStyle(
                                      color:
                                          Theme.of(ctx).textTheme.title.color),
                                  content: Column(
                                    children: <Widget>[
                                      Text("Review schreiben")
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: Colors.red,
                                      child: Text(
                                        "Abbrechen",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                    FlatButton(
                                      color: Colors.green,
                                      child: Text(
                                        "Abgeben",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        addNewReview(
                                            new Review(
                                                (reviewedAnime
                                                        .reviews.first.id +
                                                    1),
                                                reviewedAnime.id,
                                                snapshot.data.user.id,
                                                "",
                                                null,
                                                snapshot.data.user),
                                            ctx);
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ))
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class ReviewInfo {
  User user;
  ReviewShow reviewShow;

  ReviewInfo(this.reviewShow, this.user);
}
