import 'package:aniflix_app/api/objects/Group.dart';
import 'package:aniflix_app/api/objects/Show.dart';

class UserProfile{
  int id;
  String name;
  String avatar;
  String banned_until;
  String created_at;
  String updated_at;
  String deleted_at;
  String banreason;
  String about_me;
  List<Group> groups;
  List<Show> favorites;

  UserProfile(
      this.id,
      this.name,
      this.avatar,
      this.banned_until,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.banreason,
      this.about_me,
      this.groups,
      this.favorites);

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserProfile(
        json["id"],
        json["name"],
        json["avatar"],
        json["banned_until"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["banreason"],
        json["about_me"],
        Group.getGroups(json["groups"]),
        Show.getShows(json["favorites"]));
  }
}
