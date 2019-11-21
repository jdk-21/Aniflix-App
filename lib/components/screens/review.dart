import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ReviewScreen extends Container{

  Future<ReviewShow> reviewData;
  String url;

  ReviewScreen(this.url){
    reviewData = APIManager.getReviews(url);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("home_screen"),
      child: FutureBuilder<ReviewShow>(
        future: reviewData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                color: Theme.of(ctx).backgroundColor);
                } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
      ),);
  }
}