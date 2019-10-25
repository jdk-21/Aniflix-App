import 'package:aniflix_app/api/objects/Group.dart';

class User {
  int id;
  String name;
  String avatar;
  DateTime banned_until;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String access_key;
  List<Group> groups;

  User(this.id, this.name, this.avatar, this.banned_until, this.created_at,
      this.updated_at, this.deleted_at, this.access_key, this.groups);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json["id"],
        json["name"],
        json["avatar"],
        DateTime.parse(json["banned_until"]),
        DateTime.parse(json["created_at"]),
        DateTime.parse(json["updated_at"]),
        DateTime.parse(json["deleted_at"]),
        json["access_key"],
        Group.getGroups(json["groups"]));
  }
}
