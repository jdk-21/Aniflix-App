import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/components/custom/episode/episodeHeader.dart';
import 'package:aniflix_app/components/custom/episode/animePlayer.dart';
import 'package:aniflix_app/components/custom/episode/episodeBar.dart';
import 'package:aniflix_app/components/custom/episode/comments/commentList.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  List<Comment> comments;
  Future<LoadInfo> episodeInfo;
  String name;
  int season;
  int number;
  EpisodeBarState barState;
  EpisodeHeaderState episodeHeaderState;

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

  updateEpisodeData(String name, int season, int number) {
    setState(() {
      print(name);
      print(season);
      print(number);
      this.name = name;
      this.season = season;
      this.number = number;
      this._hosters = null;
      this._langs = null;
      this._stream = null;
      this.comments = null;
      this.episodeInfo = APIManager.getEpisodeInfo(name, season, number);

      this.episodeInfo.then((episode) {
        if (episode.episodeInfo != null) {
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
          if (snapshot.hasData && snapshot.data.episodeInfo != null) {
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
            }
            return Container(
                color: Theme.of(ctx).backgroundColor,
                child: ListView(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  children: <Widget>[
                    EpisodeHeader(episode, () {
                      updateEpisodeData(
                          this.name, this.season, (this.number - 1));
                    }, () {
                      updateEpisodeData(
                          this.name, this.season, (this.number + 1));
                    }, (lang, hoster) {
                      updateStream(episode, lang, hoster);
                    }, (state) {
                      episodeHeaderState = state;
                    }),
                    (_stream != null) ? AnimePlayer(_stream) : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    EpisodeBar(episode, mainState, (state) {
                      this.barState = state;
                    }),
                    new CommentList(
                        snapshot.data.user, episode, this.comments, ctx,
                        (text) {
                      APIManager.addComment(episode.id, text).then((comment) {
                        if (comment != null) {
                          setState(() {
                            comments.insert(0, comment);
                          });
                        }
                      });
                    }, (id, text) {
                      APIManager.addSubComment(id, text).then((comment) {
                        if (comment != null) {
                          setState(() {
                            for (var c in comments) {
                              if (c.id == id) {
                                c.comments.add(comment);
                              }
                            }
                          });
                        }
                      });
                    },(id){
                          setState(() {
                            for(var i = 0; i < comments.length; i++){
                              if(comments[i].id == id){
                                comments.removeAt(i);
                                APIManager.deleteComment(id);
                                break;
                              }
                            }
                          });
                    },(id,sub_id){
                      setState(() {
                        for(var i = 0; i < comments.length; i++){
                          if(comments[i].id == id){
                            for(var j = 0; j < comments[i].comments.length; j++){
                              if(comments[i].comments[j].id == sub_id){
                                comments[i].comments.removeAt(j);
                                APIManager.deleteComment(sub_id);
                                break;
                              }
                            }
                          }
                        }
                      });
                    },this)
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
