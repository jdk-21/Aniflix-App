import 'package:aniflix_app/api/objects/Pivot.dart';

class Group {
  int id;
  String name;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  Pivot pivot;

  Group(this.id, this.name, this.created_at, this.updated_at, this.deleted_at,
      this.pivot);
  factory Group.fromJson(Map<String, dynamic> json){
    return Group(json["id"], json["name"],DateTime.parse(json["created_at"]), DateTime.parse(json["updated_at"]), DateTime.parse(json["deleted_at"]), Pivot.fromJson(json["pivot"]));
  }

  static List<Group> getGroups(List<Map<String, dynamic>> json){
    List<Group> groups;
    for(var entry in json){
      groups.add(Group.fromJson(entry));
    }
    return groups;
  }

}
