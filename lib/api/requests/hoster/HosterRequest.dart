import 'dart:convert';

import 'package:aniflix_app/api/objects/Hoster.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';

class HosterRequest {
  static Future<List<Hoster>> getHosters() async {
    List<Hoster> hoster = [];
    var response =
        await AniflixRequest("hosters", type: AniflixRequestType.No_Login)
            .get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        hoster.add(Hoster.fromJson(entry));
      }
    }
    return hoster;
  }
}
