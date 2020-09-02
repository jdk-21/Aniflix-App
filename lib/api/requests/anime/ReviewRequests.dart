import 'dart:convert';

import 'package:aniflix_app/api/objects/anime/reviews/Review.dart';
import 'package:aniflix_app/api/objects/anime/reviews/ReviewShow.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/api/requests/user/ProfileRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/review.dart';

class ReviewRequests {
  static Future<ReviewShow> _getReviews(String name) async {
    ReviewShow review;

    var response = await AniflixRequest("show/reviews/" + name,
            type: AniflixRequestType.No_Login)
        .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      review = ReviewShow.fromJson(json);
    }

    return review;
  }

  static Future<ReviewInfo> getReviewInfo(String name) async {
    var info = await _getReviews(name);
    var user = CacheManager.userData;

    return ReviewInfo(info, user);
  }

  static Future<Review> createReview(int show_id, String text) async {
    var response = await AniflixRequest("review")
        .post(bodyObject: {"show_id": show_id.toString(), "text": text});
    var review;
    if (response.statusCode != 404) {
      var json = jsonDecode(response.body);
      review = Review.fromJson(json);
    }
    return review;
  }

  static void deleteReview(int id) {
    AniflixRequest("review/" + id.toString()).delete();
  }
}
