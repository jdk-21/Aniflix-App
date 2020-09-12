import 'dart:convert';

import 'package:aniflix_app/api/objects/history/historyEpisode.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';

class HistoryRequests {
  static Future<Historydata> getHistory() async {
    List<HistoryEpisode> episodes = [];
    var response = await AniflixRequest("show/history").post();

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as List;
      for (var entry in json) {
        var episode = HistoryEpisode.fromJson(entry);
        episodes.add(episode);
      }
    }

    return Historydata(episodes);
  }
}
