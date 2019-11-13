class Vote {
  int id;
  String voteable_type;
  int voteable_id;
  int user_id;
  int value;
  String created_at;
  String updated_at;
  String deleted_at;

  Vote(this.id, this.voteable_type, this.voteable_id, this.user_id,this.value, this.created_at,
      this.updated_at, this.deleted_at);

  factory Vote.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    return Vote(
        json["id"],
        json["voteable_type"],
        json["voteable_id"],
        json["user_id"],
        json["value"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
    );
  }

  static List<Vote> getVotes(List<dynamic> json) {
    List<Vote> votes = [];
    if(json != null){
      for (var entry in json) {
        var vote = Vote.fromJson(entry);
        if(vote != null) votes.add(vote);
      }
    }
    return votes;
  }

}
