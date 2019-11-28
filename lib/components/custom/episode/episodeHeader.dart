import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/api/objects/Stream.dart';

class EpisodeHeader extends StatefulWidget {
  EpisodeInfo episode;
  Function prev;
  Function next;
  Function(int lang,int hoster) change;

  EpisodeHeader(this.episode, this.prev, this.next, this.change);

  @override
  EpisodeHeaderState createState() =>
      EpisodeHeaderState(this.episode, this.prev, this.next, this.change);
}

class EpisodeHeaderState extends State<EpisodeHeader> {
  EpisodeInfo episode;
  Function prev;
  Function next;
  Function(int lang,int hoster) change;
  int _language;
  int _hoster;
  List<String> _hosters;

  EpisodeHeaderState(this.episode, this.prev, this.next, this.change){
    _hosters = [];
  }

  @override
  void initState() {
    _language = 0;
    _hoster = 0;
    for (var stream in episode.streams) {
      if (!_hosters.contains(stream.hoster.name)) {
        _hosters.add(stream.hoster.name);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        (episode.number > 1)
            ? IconButton(
                icon: Icon(
                  Icons.navigate_before,
                  color: Theme.of(ctx).textTheme.title.color,
                ),
                color: Theme.of(ctx).textTheme.title.color,
                onPressed: prev,
              )
            : IconButton(
                icon: Icon(
                  Icons.navigate_before,
                  color: Theme.of(ctx).backgroundColor,
                ),
                color: Theme.of(ctx).backgroundColor,
                onPressed: () {},
              ),
        Row(
          children: <Widget>[
            Theme(
              data: Theme.of(ctx)
                  .copyWith(canvasColor: Theme.of(ctx).backgroundColor),
              child: DropdownButton(
                style: TextStyle(
                    color: Theme.of(ctx).textTheme.title.color, fontSize: 15),
                onChanged: (val) {
                  setState(() {
                    _language = val;
                  });
                  change(_language,_hoster);
                },
                items: getLanguagesAsDropdownList(episode.streams,ctx),
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
                    color: Theme.of(ctx).textTheme.title.color, fontSize: 15),
                onChanged: (newValue) {
                  setState(() {
                    _hoster = newValue;
                  });
                  change(_language,_hoster);
                },
                items: getHosters(ctx),
                value: _hoster,
              ),
            ),
          ],
        ),
        IconButton(
          icon: (episode.next != "")
              ? Icon(
                  Icons.navigate_next,
                  color: Theme.of(ctx).textTheme.title.color,
                )
              : Icon(
                  Icons.navigate_before,
                  color: Theme.of(ctx).backgroundColor,
                ),
          color: (episode.next != "")
              ? Theme.of(ctx).textTheme.title.color
              : Theme.of(ctx).backgroundColor,
          onPressed: (episode.next != "") ? next : () {},
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
      namelist
          .add(DropdownMenuItem(value: l, child: ThemeText(languages.elementAt(l),ctx)));
    }
    return namelist;
  }
  List<DropdownMenuItem> getHosters(BuildContext ctx){
    var list = <DropdownMenuItem>[];
    var i = 0;
    for (var hoster in _hosters) {
      list.add(DropdownMenuItem(value: i, child: ThemeText(hoster,ctx)));
      i++;
    }
    return list;
  }
}
