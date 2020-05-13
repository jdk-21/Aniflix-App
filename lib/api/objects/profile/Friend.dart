import 'package:aniflix_app/api/objects/User.dart';

class Friend{
  int id;
  int user_id;
  int friend_id;
  int status;
  String created_at;
  String updated_at;
  String deleted_at;
  User user;
  User friend;

  Friend(
      this.id,
      this.user_id,
      this.friend_id,
      this.status,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.user,
      this.friend);

  factory Friend.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Friend(
        json["id"],
        json["user_id"],
        json["friend_id"],
        json["status"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        User.fromJson(json["user"]),
        User.fromJson(json["friend"]));
  }

  static List<Friend> getFriends(List<dynamic> json) {
    List<Friend> friends = [];
    for (var entry in json) {
      friends.add(Friend.fromJson(entry));
    }
    return friends;
  }
}

class FriendListData{
  List<Friend> friendlist;
  FriendListData(this.friendlist);
}
