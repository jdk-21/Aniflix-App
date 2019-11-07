class UserPivot {
  int user_id;
  int group_id;

  UserPivot(this.user_id, this.group_id);

  factory UserPivot.fromJson(Map<String, dynamic> json) {
    return UserPivot(json["user_id"], json["group_id"]);
  }
}
