import 'package:aniflix_app/api/objects/Pivot.dart';

class Group {
  int id;
  String name;
  String created_at;
  String updated_at;
  String deleted_at;
  Pivot pivot;

  Group(this.id, this.name, this.created_at, this.updated_at, this.deleted_at,
      this.pivot);

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        json["id"],
        json["name"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        Pivot.fromJson(json["pivot"]));
  }

  static List<Group> getGroups(List<dynamic> json) {
    List<Group> groups = [];
    for (var entry in json) {
      groups.add(Group.fromJson(entry));
    }
    return groups;
  }
}
