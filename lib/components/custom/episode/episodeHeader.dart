import 'package:aniflix_app/api/objects/Hoster.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/Stream.dart';

class EpisodeHeader extends StatefulWidget {
  LoadInfo episode;
  Function prev;
  Function next;
  Function(int lang, int hoster, int view) change;
  Function(EpisodeHeaderState) _created;

  EpisodeHeader(this.episode, this.prev, this.next, this.change, this._created);

  @override
  EpisodeHeaderState createState() => EpisodeHeaderState(
      this.episode, this.prev, this.next, this.change, this._created);
}

class EpisodeHeaderState extends State<EpisodeHeader> {
  LoadInfo load;
  EpisodeInfo episode;
  Function prev;
  Function next;
  Function(int lang, int hoster, int view) change;
  Function(EpisodeHeaderState) _created;
  int _language;
  int _hoster;
  int _view;
  List<String> _hosters;

  EpisodeHeaderState(
      this.load, this.prev, this.next, this.change, this._created) {
    _hosters = [];
    _view = 0;
  }

  void init() {
    this.episode = this.load.episodeInfo;
    _language = 0;
    _hoster = 0;
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

    var user = load.user;
    if(user.settings != null) {
      for (var stream in episode.streams) {
        if (user.settings.preferred_hoster_id == stream.hoster_id) {
          _hoster = _hosters.indexOf(stream.hoster.name);
          if (stream.lang == user.settings.preferred_lang) {
            _language = (user.settings.preferred_lang == "SUB") ? 0 : 1;
          }
          break;
        }
      }
    }
    _created(this);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  updateEpisode(EpisodeInfo episode) {
    setState(() {
      this.episode = episode;
      init();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            (episode.number > 1)
                ? IconButton(
                    icon: Icon(
                      Icons.navigate_before,
                      color: Theme.of(ctx).textTheme.caption.color,
                    ),
                    color: Theme.of(ctx).textTheme.caption.color,
                    onPressed: prev,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.navigate_before,
                      color: Colors.transparent,
                    ),
                    color: Colors.transparent,
                    onPressed: () {},
                  ),
            Row(
              children: <Widget>[
                Theme(
                  data: Theme.of(ctx)
                      .copyWith(canvasColor: Theme.of(ctx).backgroundColor),
                  child: DropdownButton(
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.caption.color,
                        fontSize: 15),
                    onChanged: (val) {
                      setState(() {
                        _language = val;
                      });
                      change(_language, _hoster, _view);
                    },
                    items: getLanguagesAsDropdownList(episode.streams, ctx),
                    value: _language,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Theme(
                  data: Theme.of(ctx)
                      .copyWith(canvasColor: Theme.of(ctx).backgroundColor),
                  child: DropdownButton(
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.caption.color,
                        fontSize: 15),
                    onChanged: (newValue) {
                      setState(() {
                        _hoster = newValue;
                      });
                      change(_language, _hoster, _view);
                    },
                    items: getHosters(ctx),
                    value: _hoster,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            IconButton(
              icon: (episode.next != "")
                  ? Icon(
                      Icons.navigate_next,
                      color: Theme.of(ctx).textTheme.caption.color,
                    )
                  : Icon(
                      Icons.navigate_before,
                      color: Colors.transparent,
                    ),
              color: (episode.next != "")
                  ? Theme.of(ctx).textTheme.caption.color
                  : Colors.transparent,
              onPressed: (episode.next != "") ? next : () {},
            ),
          ],
        ),
        Theme(
          data: Theme.of(ctx)
              .copyWith(canvasColor: Theme.of(ctx).backgroundColor),
          child: DropdownButton(
              style: TextStyle(
                  color: Theme.of(ctx).textTheme.caption.color, fontSize: 15),
              onChanged: (newValue) {
                setState(() {
                  _view = newValue;
                });
                change(_language, _hoster, _view);
              },
              items: getPlayers(ctx),
              value: _view),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> getLanguagesAsDropdownList(
      List<AnimeStream> streams, BuildContext ctx) {
    List<DropdownMenuItem<int>> namelist = [];
    List<String> languages = [];
    for (var stream in streams) {
      if (!languages.contains(stream.lang)) {
        languages.add(stream.lang);
      }
    }
    for (int l = 0; l < languages.length; l++) {
      namelist.add(
          DropdownMenuItem(value: l, child: ThemeText(languages.elementAt(l))));
    }
    return namelist;
  }

  List<DropdownMenuItem> getHosters(BuildContext ctx) {
    var list = <DropdownMenuItem>[];
    var i = 0;
    for (var hoster in _hosters) {
      list.add(DropdownMenuItem(value: i, child: ThemeText(hoster)));
      i++;
    }
    return list;
  }

  List<DropdownMenuItem> getPlayers(BuildContext ctx) {
    var list = <DropdownMenuItem>[];
    list.add(DropdownMenuItem(value: 0, child: ThemeText("InApp Browser")));
    list.add(DropdownMenuItem(value: 1, child: ThemeText("Browser")));
    list.add(
        DropdownMenuItem(value: 2, child: ThemeText("InAppView (Unstable)")));
    return list;
  }
}
