import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:aniflix_app/components/custom/dialogs/writeReviewDialog.dart';
import 'package:aniflix_app/components/custom/review/reviewElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';

class ReviewScreen extends StatefulWidget implements Screen {
  String url;

  ReviewScreen(this.url);

  @override
  getScreenName() {
    return "review_screen";
  }

  @override
  ReviewScreenState createState() => ReviewScreenState(url);
}

class ReviewScreenState extends State<ReviewScreen> {
  Future<ReviewInfo> reviewData;
  String url;
  List<ReviewElement> _actualReviews = [];
  bool _showButton = true;

  addNewReview(
      Review review, User user, BuildContext ctx, ReviewShow reviewInfo) async {
    var responsereview =
        await APIManager.createReview(reviewInfo.id, review.text);
    responsereview.user = user;
    setState(() {
      _actualReviews.insert(
          0,
          ReviewElement(responsereview, user, (id) {
            for (var i = 0; i < _actualReviews.length; i++) {
              if (_actualReviews[i].review.id == id) {
                setState(() {
                  _actualReviews.removeAt(i);
                  _showButton = true;
                });
                break;
              }
            }
          }, ctx));
      _showButton = false;
    });
  }

  ReviewScreenState(this.url) {
    reviewData = APIManager.getReviewInfo(url);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("review_screen"),
      color: Colors.transparent,
      child: FutureBuilder<ReviewInfo>(
        future: reviewData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var reviewedAnime = snapshot.data.reviewShow;
            if (_actualReviews.length < 1) {
              for (var review in reviewedAnime.reviews) {
                _actualReviews
                    .add(ReviewElement(review, snapshot.data.user, (id) {
                  for (var i = 0; i < _actualReviews.length; i++) {
                    if (_actualReviews[i].review.id == id) {
                      setState(() {
                        _actualReviews.removeAt(i);
                        _showButton = true;
                      });
                      break;
                    }
                  }
                }, ctx));
                if (review.user_id == snapshot.data.user.id) {
                  _showButton = false;
                }
              }
            }
            return Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                  color: Colors.transparent,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: ThemeText(
                                "Reviews zu",
                                fontWeight: FontWeight.bold,
                                softWrap: true,
                              )),
                          Align(
                            alignment: Alignment.center,
                            child: ThemeText(
                              reviewedAnime.name,
                              fontWeight: FontWeight.bold,
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
                      _showButton
                          ? Align(
                              alignment: Alignment.center,
                              child: OutlineButton(
                                textColor: Theme.of(ctx).textTheme.caption.color,
                                borderSide: BorderSide(
                                    color: Theme.of(ctx).textTheme.caption.color),
                                child: ThemeText("Review schreiben"),
                                onPressed: () {
                                  showDialog(
                                      context: ctx,
                                      builder: (BuildContext context) {
                                        return WriteReviewDialog((review) {
                                          addNewReview(
                                              review,
                                              snapshot.data.user,
                                              ctx,
                                              reviewedAnime);
                                        }, reviewedAnime, snapshot.data.user);
                                      });
                                },
                              ))
                          : SizedBox()
                    ],
                  ),
                ))
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
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
