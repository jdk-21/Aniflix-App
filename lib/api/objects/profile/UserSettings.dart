class UserSettings {
  int id;
  int user_id;
  bool show_friends;
  bool show_watchlist;
  bool show_abos;
  bool show_favorites;
  bool show_list;
  String background_image;
  String created_at;
  String updated_at;
  String deleted_at;
  String preferred_lang;
  int preferred_hoster_id;

  UserSettings(
      this.id,
      this.user_id,
      this.show_friends,
      this.show_watchlist,
      this.show_abos,
      this.show_favorites,
      this.show_list,
      this.background_image,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.preferred_lang,
      this.preferred_hoster_id);

  factory UserSettings.fromObject(UserSettings object) {
    return UserSettings(
        object.id,
        object.user_id,
        object.show_friends,
        object.show_watchlist,
        object.show_abos,
        object.show_favorites,
        object.show_list,
        object.background_image,
        object.created_at,
        object.updated_at,
        object.deleted_at,
        object.preferred_lang,
        object.preferred_hoster_id);
  }

  factory UserSettings.fromJsonList(List<dynamic> list) {
    if (list == null) return null;
    if (list.isEmpty) return null;
    Map<String, dynamic> json = list[0];
    return UserSettings.fromJson(json);
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserSettings(
        json["id"],
        json["user_id"],
        json["show_friends"] == 1,
        json["show_watchlist"] == 1,
        json["show_abos"] == 1,
        json["show_favorites"] == 1,
        json["show_list"] == 1,
        json["background_image"],
        json["created_at"],
        json["updated_at"],
        json["deleted_at"],
        json["preferred_lang"],
        json["preferred_hoster_id"]);
  }
}
