import 'package:aniflix_app/api/objects/Group.dart';

class User {
  int id;
  String name;
  String avatar;
  String banned_until;
  String created_at;
  String updated_at;
  String deleted_at;
  String banreason;
  String about_me;
  String access_key;
  List<Group> groups;

  User(
      this.id,
      this.name,
      this.avatar,
      this.banned_until,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.banreason,
      this.about_me,
      this.access_key,
      this.groups);

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
        json["id"],
        json["name"],
        json["avatar"],
        json["banned_until"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["banreason"],
        json["about_me"],
        json["access_key"],
        Group.getGroups(json["groups"]));
  }

  static List<User> getUsers(List<dynamic> json) {
    List<User> users = [];
    for (var entry in json) {
      users.add(User.fromJson(entry));
    }
    return users;
  }
}
