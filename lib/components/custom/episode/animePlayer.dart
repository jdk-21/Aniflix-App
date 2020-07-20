import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimePlayerController {
  AnimeStream stream;
  int view;
  AnimePlayerState state;

  AnimePlayerController(this.stream, this.view);

  changeStream(AnimeStream stream) {
    this.stream = stream;
    if (state != null) {
      state.setStream(stream);
    }
  }

  changeView(int view) {
    this.view = view;
    if (state != null) {
      state.setView(view);
    }
  }
}

class AnimePlayer extends StatefulWidget {
  final AnimePlayerController _controller;

  AnimePlayer(this._controller);

  @override
  State<StatefulWidget> createState() => AnimePlayerState(this._controller);
}

class AnimePlayerState extends State<AnimePlayer> {
  AnimeStream _stream;
  int _view;
  final AnimePlayerController _controller;
  InAppWebViewController _webcontroller;

  AnimePlayerState(this._controller) {
    this._stream = _controller.stream;
    this._view = _controller.view;
    if (_controller.state == null) {
      _controller.state = this;
    }
  }

  setStream(AnimeStream stream) {
    setState(() {
      print("setStream");
      this._stream = stream;
    });
  }

  setView(int view) {
    setState(() {
      print("setView");
      this._view = view;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(10),
      child: getPlayer(ctx),
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: Theme.of(ctx).textTheme.caption.color)),
      height: 200,
    );
  }

  Widget getPlayer(BuildContext ctx) {
    if (_view == 0) {
      return Center(
          child: IconButton(
              icon: Icon(Icons.play_circle_outline, size: 50),
              color: Theme.of(ctx).accentIconTheme.color,
              onPressed: () => openInApp()));
    } else if (_view == 1) {
      return Center(
          child: IconButton(
              icon: Icon(Icons.play_circle_outline, size: 50),
              color: Theme.of(ctx).accentIconTheme.color,
              onPressed: () => openBrowser()));
    } else if (_view == 2) {
      if (HosterParser.parser.containsKey(_stream.hoster_id)) {
        return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var source = snapshot.data;
                if (_webcontroller != null) {
                  _webcontroller.loadUrl(url: source);
                }
                return InAppWebView(
                    initialOptions: InAppWebViewWidgetOptions(),
                    initialUrl: source,
                    onWebViewCreated: (controller) => setState(() {
                          _webcontroller = controller;
                        }));
              }
              return Center(child: CircularProgressIndicator());
            },
            future: HosterParser.parser[_stream.hoster_id]
                .parseHoster(_stream.link));
      }
      return Center(
          child:
              ThemeText("Der Hoster unterstützt noch nicht den InApp-Player!"));
    }
    print("8");
    return Center(child: ThemeText("Player konnte nicht geladen werden!"));
  }

  openInApp() {
    ChromeSafariBrowser().open(
        url: _stream.link,
        options: ChromeSafariBrowserClassOptions(
            android: AndroidChromeCustomTabsOptions(addShareButton: false),
            ios: IOSSafariOptions(barCollapsingEnabled: true)));
  }

  openBrowser() {
    open(_stream.link);
  }

  open(url) async {
    if (await canLaunch(url)) {
      launch(url);
    }
  }
}
