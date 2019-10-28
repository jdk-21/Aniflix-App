class Pivot {
  int user_id;
  int group_id;

  Pivot(this.user_id, this.group_id);

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(json["user_id"], json["group_id"]);
  }
}
