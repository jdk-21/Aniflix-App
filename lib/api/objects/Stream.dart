import 'package:aniflix_app/api/objects/Hoster.dart';
import 'package:aniflix_app/api/objects/User.dart';

class AnimeStream {
  int id;
  String streamable_type;
  int streamable_id;
  int hoster_id;
  int user_id;
  String link;
  String lang;
  String created_at;
  String updated_at;
  String deleted_at;
  Hoster hoster;
  User user;

  AnimeStream(
      this.id,
      this.streamable_type,
      this.streamable_id,
      this.hoster_id,
      this.user_id,
      this.link,
      this.lang,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.hoster,
      this.user);

  factory AnimeStream.fromJson(Map<String, dynamic> json) {
    return AnimeStream(
        json["id"],
        json["streamable_type"],
        json["streamable_id"],
        json["hoster_id"],
        json["user_id"],
        json["link"],
        json["lang"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        Hoster.fromJson(json["hoster"]),
        User.fromJson(json["user"]));
  }

  static List<AnimeStream> getStreams(List<dynamic> json) {
    List<AnimeStream> streams = [];
    for (var entry in json) {
      streams.add(AnimeStream.fromJson(entry));
    }
    return streams;
  }
}
