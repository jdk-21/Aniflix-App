import './Review.dart';
class ReviewShow {
  int id;
  String name;
  String name_alt;
  String url;
  String description;
  String cover_landscape;
  String cover_landscape_original;
  String cover_portrait;
  String visible_since;
  String created_at;
  String updated_at;
  String deleted_at;
  int howManyAbos;
  int seasonCount;
  String rating;
  int airing;
  List<Review> reviews;

  ReviewShow(
      this.id,
      this.name,
      this.name_alt,
      this.url,
      this.description,
      this.cover_landscape,
      this.cover_landscape_original,
      this.cover_portrait,
      this.visible_since,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.howManyAbos,
      this.seasonCount,
      this.rating,
      this.airing,
      this.reviews);

  factory ReviewShow.fromJson(Map<String, dynamic> json) {
    return ReviewShow(
        json["id"],
        json["name"],
        json["name_alt"],
        json["url"],
        json["description"],
        json["cover_landscape"],
        json["cover_landscape_original"],
        json["cover_portrait"],
        json["visible_since"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["howManyAbos"],
        json["seasonCount"],
        json["rating"].toString(),
        json["airing"],
      Review.getReviews(json["reviews"])
    );
  }
}
