class News{
  int id;
  String text;
  int user_id;
  String show_from;
  String show_until;
  String created_at;
  String updated_at;
  String deleted_at;

  News(this.id,this.text,this.user_id,this.show_from,this.show_until,this.created_at, this.updated_at, this.deleted_at);
  factory News.fromJson(Map<String, dynamic> json) {
    return News(json["id"], json["text"], json["user_id"], json["show_from"], json["show_until"], json["created_at"], json["updated_at"], json["deleted_at"]);
  }
}