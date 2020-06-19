import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class AnimePlayer extends StatelessWidget {
  final AnimeStream _stream;
  final int _view;
  final InAppWebView _inApp;
  final InAppWebViewController _controller;
  final Function(ChewieController) _onControllerInit;

  AnimePlayer(this._stream, this._view, this._inApp, this._controller, this._onControllerInit);

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

  getPlayer(BuildContext ctx) {
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
        var parser = HosterParser.parser[_stream.hoster_id];
        return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var controller = VideoPlayerController.network(snapshot.data);
                var chewieController = ChewieController(
                  videoPlayerController: controller,
                  aspectRatio: 3 / 2,
                  autoPlay: true,
                  looping: true
                );
                _onControllerInit(chewieController);
                return Chewie(controller: chewieController);
              }
              return Center(child: CircularProgressIndicator());
            },
            future: parser.parseHoster(_stream.link));
      }

      if (_controller != null) {
        _controller.loadUrl(url: _stream.link);
      }
      return _inApp;
    }
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
      await launch(url);
    }
  }
}
