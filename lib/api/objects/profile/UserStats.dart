class UserStats{
  int points;
  int seen;
  String time;
  int user_id;
  int group_id;

  UserStats(this.points,this.seen,this.time,this.user_id, this.group_id);
  factory UserStats.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserStats(
        json["points"],
        json["seen"],
        json["time"],
        json["user_id"],
        json["group_id"]);
  }
}