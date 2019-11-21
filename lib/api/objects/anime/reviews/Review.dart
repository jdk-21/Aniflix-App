import '../Vote.dart';
import '../../User.dart';

class Review{
  int id;
  int show_id;
  int user_id;
  String text;
  String created_at;
  String updated_at;
  String deleted_at;
  Vote vote;
  User user;

  Review(this.id, this.show_id,this.user_id,this.text,this.created_at,this.updated_at,this.deleted_at,this.vote,this.user);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        json["id"],
        json["show_id"],
        json["user_id"],
        json["text"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
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