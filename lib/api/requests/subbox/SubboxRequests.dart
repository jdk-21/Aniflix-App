import 'dart:convert';

import 'package:aniflix_app/api/objects/subbox/SubEpisode.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/components/screens/subbox.dart';

class SubboxRequests {
  static Future<Subdata> getSubData() async {
    List<SubEpisode> episodes = [];
    var response = await AniflixRequest("abos/abos/0").get();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        episodes.add(SubEpisode.fromJson(entry));
      }
    }
    return Subdata(episodes);
  }
}
