import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:aniflix_app/components/custom/dialogs/writeReviewDialog.dart';
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
  bool _showButton = true;

  addNewReview(Review review, BuildContext ctx, ReviewShow reviewInfo) {
    setState(() {
      _actualReviews.insert(0, ReviewElement(review, ctx));
      _showButton = false;
    });
    APIManager.createReview(reviewInfo.id, review.text);
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
                if(review.user_id == snapshot.data.user.id){
                  _showButton = false;
                }
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
                  _showButton ?
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
                              builder: (BuildContext context) {
                                return WriteReviewDialog((review){addNewReview(review, ctx, reviewedAnime);}, reviewedAnime, snapshot.data.user);
                              });
                        },
                      )) : SizedBox()
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
