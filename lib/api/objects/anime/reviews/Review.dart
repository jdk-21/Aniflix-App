import '../Vote.dart';
import '../../User.dart';

class Review{
  int id;
  int show_id;
  int user_id;
  String text;
  Vote vote;
  User user;

  Review(this.id, this.show_id,this.user_id,this.text,this.vote,this.user);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        json["id"],
        int.parse(json["show_id"].toString()),
        json["user_id"],
        json["text"],
        Vote.fromJson(json["vote"]),
        User.fromJson(json["user"])
    );
  }

  static List<Review> getReviews(List<dynamic> json) {
    List<Review> reviews = [];
    if(json != null){
      for (var entry in json) {
        var review = Review.fromJson(entry);
        if(review != null)reviews.add(review);
      }
    }
    return reviews;
  }
}