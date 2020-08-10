import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Hoster.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/components/custom/episode/episodeHeader.dart';
import 'package:aniflix_app/components/custom/episode/animePlayer.dart';
import 'package:aniflix_app/components/custom/episode/episodeBar.dart';
import 'package:aniflix_app/components/custom/episode/comments/commentList.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EpisodeScreenArguments {
  String name;
  int season;
  int number;
  Future<LoadInfo> episodeInfo;

  EpisodeScreenArguments(this.name, this.season, this.number,
      {this.episodeInfo});
}

class EpisodeScreen extends StatefulWidget implements Screen {
  String name;
  int season;
  int number;
  Future<LoadInfo> _episodeInfo;

  EpisodeScreen(this.name, this.season, this.number);

  EpisodeScreen.withData(
      this.name, this.season, this.number, this._episodeInfo);

  @override
  getScreenName() {
    return "episode_screen";
  }

  @override
  EpisodeScreenState createState() =>
      EpisodeScreenState(name, season, number, _episodeInfo);
}

class EpisodeScreenState extends State<EpisodeScreen> {
  AnimeStream _stream;
  List<String> _hosters;
  List<String> _langs;
  List<Comment> comments;
  Future<LoadInfo> episodeInfo;
  String name;
  int season;
  int number;
  int view;
  EpisodeBarState barState;
  EpisodeHeaderState episodeHeaderState;
  AnimePlayerController _controller;

  updateStream(EpisodeInfo episodeInfo, int lang, int hoster) {
    setState(() {
      for (var stream in episodeInfo.streams) {
        if (_hosters[hoster] == stream.hoster.name &&
            _langs[lang] == stream.lang) {
          var analytics = AppState.analytics;
          analytics.logEvent(name: "episode_change_stream", parameters: {
            "episode_id": episodeInfo.id,
            "lang": stream.lang,
            "hoster_id": stream.hoster_id,
            "hoster_name": stream.hoster.name
          });
          this._stream = stream;
          _controller.changeStream(stream);
          return;
        }
      }
    });
  }

  updateEpisodeData(String name, int season, int number) {
    setState(() {
      this.name = name;
      this.season = season;
      this.number = number;
      this._hosters = null;
      this._langs = null;
      this._stream = null;
      this.comments = null;
      this.view = null;
      this._controller = null;
      //TODO dispose Player?
      this.episodeInfo = APIManager.getEpisodeInfo(name, season, number);

      this.episodeInfo.then((episode) {
        if (episode.episodeInfo != null) {
          var info = episode.episodeInfo;
          var itemName = "Show_" +
              info.season.show.name +
              "_Season_" +
              info.season.number.toString() +
              "_Episode_" +
              info.number.toString();
          AppState.analytics.logViewItem(
              itemId: info.id.toString(),
              itemName: itemName,
              itemCategory: "Episode");
          if (barState != null) {
            barState.updateEpisode(episode.episodeInfo);
          }

          if (episodeHeaderState != null) {
            episodeHeaderState.updateEpisode(episode.episodeInfo);
          }
          comments = episode.episodeInfo.comments;
        }
      }).catchError((error) {
        print(error);
      });
    });
  }

  EpisodeScreenState(this.name, this.season, this.number, this.episodeInfo) {
    if (episodeInfo == null) {
      this.episodeInfo = APIManager.getEpisodeInfo(name, season, number);
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("episode_screen"),
      color: Colors.transparent,
      child: FutureBuilder<LoadInfo>(
        future: episodeInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.episodeInfo != null) {
            var episode = snapshot.data.episodeInfo;
            if (view == null) {
              view = 0;
            }
            if (_hosters == null) {
              _hosters = [];
              List<Hoster> hosters = [];
              for (var stream in episode.streams) {
                if (hosters.length > 0) {
                  for (int i = hosters.length - 1; i >= 0; i--) {
                    var other = hosters[i];
                    if (other.preferred >= stream.hoster.preferred) {
                      hosters.add(stream.hoster);
                      break;
                    } else if (i == 0) {
                      hosters.insert(0, stream.hoster);
                      break;
                    }
                  }
                } else {
                  hosters.add(stream.hoster);
                }
              }
              for (var hoster in hosters) {
                if (!_hosters.contains(hoster.name)) {
                  _hosters.add(hoster.name);
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

            if (_stream == null && snapshot.data.user.settings != null) {
              var user = snapshot.data.user;
              for (var stream in episode.streams) {
                if (user.settings.preferred_hoster_id == stream.hoster_id &&
                    user.settings.preferred_lang == stream.lang) {
                  this._stream = stream;
                  break;
                }
              }
            }

            if (_stream == null) {
              for (var stream in episode.streams) {
                if (_hosters[0] == stream.hoster.name &&
                    _langs[0] == stream.lang) {
                  this._stream = stream;
                  break;
                }
              }
            }

            if (comments == null) {
              comments = episode.comments;
              var info = episode;
              var itemName = "Show_" +
                  info.season.show.name +
                  "_Season_" +
                  info.season.number.toString() +
                  "_Episode_" +
                  info.number.toString();
              AppState.analytics.logViewItem(
                  itemId: info.id.toString(),
                  itemName: itemName,
                  itemCategory: "Episode");
            }

            if (_controller == null) {
              _controller = AnimePlayerController(episode, _stream, view, this);
            }

            return Column(children: <Widget>[
              Expanded(
                  child: Container(
                      color: Colors.transparent,
                      child: ListView(
                        cacheExtent: 1000,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        children: <Widget>[
                          EpisodeHeader(snapshot.data, () {
                            var info = APIManager.getEpisodeInfo(
                                name, season, number - 1);
                            info.then((value) {
                              Navigator.pushNamed(context, "episode",
                                  arguments: EpisodeScreenArguments(
                                      name, season, number - 1,
                                      episodeInfo: info));
                            });
                          }, () {
                            var info = APIManager.getEpisodeInfo(
                                name, season, number + 1);
                            info.then((value) {
                              Navigator.pushNamed(context, "episode",
                                  arguments: EpisodeScreenArguments(
                                      name, season, number + 1,
                                      episodeInfo: info));
                            });
                          }, (lang, hoster, view) {
                            setState(() {
                              this.view = view;
                              _controller.changeView(view);
                            });
                            updateStream(episode, lang, hoster);
                          }, (state) {
                            episodeHeaderState = state;
                          }),
                          (_stream != null)
                              ? AnimePlayer(_controller)
                              : Container(),
                          EpisodeBar(episode, (state) {
                            this.barState = state;
                          }),
                          new CommentList(
                              snapshot.data.user, episode, this.comments, ctx,
                              (text) {
                            APIManager.addComment(episode.id, text)
                                .then((comment) {
                              if (comment != null) {
                                var analytics = AppState.analytics;
                                analytics.logEvent(
                                    name: "episode_comment_send",
                                    parameters: {"comment_id": comment.id});
                                setState(() {
                                  comments.insert(0, comment);
                                });
                              }
                            });
                          }, (id, text) {
                            APIManager.addSubComment(id, text).then((comment) {
                              if (comment != null) {
                                var analytics = AppState.analytics;
                                analytics.logEvent(
                                    name: "episode_comment_answer",
                                    parameters: {"comment_id": comment.id});
                                setState(() {
                                  for (var c in comments) {
                                    if (c.id == id) {
                                      c.comments.add(comment);
                                    }
                                  }
                                });
                              }
                            });
                          }, (id) {
                            setState(() {
                              for (var i = 0; i < comments.length; i++) {
                                if (comments[i].id == id) {
                                  var analytics = AppState.analytics;
                                  analytics.logEvent(
                                      name: "episode_comment_delete",
                                      parameters: {"comment_id": id});
                                  comments.removeAt(i);
                                  APIManager.deleteComment(id);
                                  break;
                                }
                              }
                            });
                          }, (id, sub_id) {
                            setState(() {
                              for (var i = 0; i < comments.length; i++) {
                                if (comments[i].id == id) {
                                  for (var j = 0;
                                      j < comments[i].comments.length;
                                      j++) {
                                    if (comments[i].comments[j].id == sub_id) {
                                      var analytics = AppState.analytics;
                                      analytics.logEvent(
                                          name: "episode_comment_delete",
                                          parameters: {"comment_id": sub_id});
                                      comments[i].comments.removeAt(j);
                                      APIManager.deleteComment(sub_id);
                                      break;
                                    }
                                  }
                                }
                              }
                            });
                          }, this)
                        ],
                      )))
            ]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
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
