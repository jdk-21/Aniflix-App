import 'package:aniflix_app/api/objects/Group.dart';

class User {
  int id;
  String name;
  String avatar;
  String banned_until;
  String created_at;
  String updated_at;
  String deleted_at;
  String access_key;
  List<Group> groups;

  User(this.id, this.name, this.avatar, this.banned_until, this.created_at,
      this.updated_at, this.deleted_at, this.access_key, this.groups);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json["id"],
        json["name"],
        json["avatar"],
        json["banned_until"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["access_key"],
        Group.getGroups(json["groups"]));
  }
}
