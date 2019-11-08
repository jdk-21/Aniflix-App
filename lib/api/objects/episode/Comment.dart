import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';

class Comment{
  int id;
  String text;
  int user_id;
  String commentable_type;
  int commentable_id;
  String created_at;
  String updated_at;
  String deleted_at;
  int voted;
  User user;
  List<Vote> votes;
  List<SubComment> comments;

  Comment(this.id,this.text,this.user_id,this.commentable_type,this.commentable_id,this.created_at,this.updated_at,this.deleted_at,this.voted,this.user,this.votes,this.comments);
  factory Comment.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return Comment(
        json["id"],
        json["text"],
        json["user_id"],
        json["commentable_type"],
        json["commentable_id"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["voted"],
        User.fromJson(json["user"]),
        Vote.getVotes(json["votes"]),
        SubComment.getComments(json["comments"]));
  }

  static List<Comment> getComments(List<dynamic> json) {
    List<Comment> comments = [];
    if(json != null){
      for (var entry in json) {
        var comment = Comment.fromJson(entry);
        if(comment != null) comments.add(comment);
      }
    }
    return comments;
  }

}

class SubComment{
  int id;
  String text;
  int user_id;
  String commentable_type;
  int commentable_id;
  String created_at;
  String updated_at;
  String deleted_at;
  int voted;
  User user;
  List<Vote> votes;

  SubComment(this.id,this.text,this.user_id,this.commentable_type,this.commentable_id,this.created_at,this.updated_at,this.deleted_at,this.voted,this.user,this.votes);
  factory SubComment.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return SubComment(
        json["id"],
        json["text"],
        json["user_id"],
        json["commentable_type"],
        json["commentable_id"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["voted"],
        User.fromJson(json["user"]),
        Vote.getVotes(json["votes"]));
  }

  static List<SubComment> getComments(List<dynamic> json) {
    List<SubComment> comments = [];
    if(json != null){
      for (var entry in json) {
        var comment = SubComment.fromJson(entry);
        if(comment != null) comments.add(comment);
      }
    }
    return comments;
  }
}