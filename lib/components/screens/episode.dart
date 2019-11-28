import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/components/custom/episode/episodeHeader.dart';
import 'package:aniflix_app/components/custom/episode/animePlayer.dart';
import 'package:aniflix_app/components/custom/episode/episodeBar.dart';
import 'package:aniflix_app/components/custom/episode/comments/commentPanel.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class EpisodeScreen extends StatefulWidget {
  MainWidgetState state;
  String name;
  int season;
  int number;

  EpisodeScreen(this.state, this.name, this.season, this.number);

  @override
  EpisodeScreenState createState() =>
      EpisodeScreenState(state, name, season, number);
}

class EpisodeScreenState extends State<EpisodeScreen> {
  MainWidgetState mainState;
  AnimeStream _stream;
  List<String> _hosters;
  List<String> _langs;
  bool _isReported;
  Future<LoadInfo> episodeInfo;
  String name;
  int season;
  int number;
  EpisodeBarState barState;
  CommentPanelState commentPanelState;

  updateStream(EpisodeInfo episodeInfo, int lang, int hoster) {
    setState(() {
      for (var stream in episodeInfo.streams) {
        if (_hosters[hoster] == stream.hoster.name &&
            _langs[lang] == stream.lang) {
          this._stream = stream;
          return;
        }
      }
    });
  }

  report() {
    setState(() {
      this._isReported = !_isReported;
    });
  }

  updateEpisodeData(String name, int season, int number) {
    setState(() {
      this.episodeInfo = APIManager.getEpisodeInfo(name, season, number);

      if (barState != null) {
        this.episodeInfo.then((episode) {
          barState.updateEpisode(episode.episodeInfo);
        });
      }
      if (commentPanelState != null) {
        this.episodeInfo.then((episode) {
          commentPanelState.updateEpisode(episode.episodeInfo);
        });
      }
      this._hosters = null;
      this._langs = null;
      this._isReported = null;
    });
  }

  EpisodeScreenState(this.mainState, this.name, this.season, this.number) {
    this.episodeInfo = APIManager.getEpisodeInfo(name, season, number);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("episode_screen"),
      child: FutureBuilder<LoadInfo>(
        future: episodeInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var episode = snapshot.data.episodeInfo;
            if (_hosters == null) {
              _hosters = [];
              for (var stream in episode.streams) {
                if (!_hosters.contains(stream.hoster.name)) {
                  _hosters.add(stream.hoster.name);
                }
              }
            }
            if (_langs == null) {
              _langs = [];
              for (var stream in episode.streams) {
                if (!_langs.contains(stream.lang)) {
                  _langs.add(stream.lang);
                }
              }
            }

            if(_stream == null){
              for (var stream in episode.streams) {
                if (_hosters[0] == stream.hoster.name &&
                    _langs[0] == stream.lang) {
                  this._stream = stream;
                  break;
                }
              }
            }
            return Container(
                color: Theme.of(ctx).backgroundColor,
                child: ListView(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  children: <Widget>[
                    ThemeText(episode.name, ctx),
                    EpisodeHeader(episode, () {
                      updateEpisodeData(episode.season.show.url,
                          episode.season.number, (episode.number - 1));
                    }, () {
                      updateEpisodeData(episode.season.show.url,
                          episode.season.number, (episode.number + 1));
                    }, (lang, hoster) {
                      updateStream(episode, lang, hoster);
                    }),
                    (_stream != null)? AnimePlayer(_stream) : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    EpisodeBar(episode, mainState, (state) {
                      this.barState = state;
                    }),
                    CommentPanel(snapshot.data.user, snapshot.data.episodeInfo,
                        (state) {
                      this.commentPanelState = state;
                    }, (text) async {
                      await APIManager.addComment(episode.id, text);
                      updateEpisodeData(episode.season.show.url,
                          episode.season.number, episode.number);
                    })
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class LoadInfo {
  User user;
  EpisodeInfo episodeInfo;

  LoadInfo(this.user, this.episodeInfo);
}
