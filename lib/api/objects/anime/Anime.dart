import 'Genre.dart';
import 'AnimeSeason.dart';
import 'Vote.dart';
import '../Airing.dart';

class Anime {
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
  Vote ownVote;
  String subscribed;
  String favorite;
  String watchlist;
  int howManyAbos;
  int seasonCount;
  String rating;
  Airing airing;
  List<AnimeSeason> seasons;
  List<Genre> genres;

  Anime(
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
      this.ownVote,
      this.subscribed,
      this.favorite,
      this.watchlist,
      this.howManyAbos,
      this.seasonCount,
      this.rating,
      this.airing,
      this.seasons,
      this.genres);

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
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
        Vote.fromJson(json["ownVote"]),
        json["subscribed"],
        json["favorite"],
        json["watchlist"],
        json["howManyAbos"],
        json["seasonCount"],
        json["rating"].toString(),
        Airing.fromJson(json["airing"]),
        AnimeSeason.getSeasons(json["seasons"]),
        null//Genre.getGenres(json["genres"])
    );
  }
}
