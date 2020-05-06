import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimePlayer extends StatelessWidget {
  AnimeStream _stream;
  int _view;
  InAppWebView _inApp;
  InAppWebViewController _controller;

  AnimePlayer(this._stream, this._view, this._inApp, this._controller);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(10),
      child: getPlayer(ctx),
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: Theme.of(ctx).textTheme.title.color)),
      height: 200,
    );
  }

  getPlayer(BuildContext ctx) {
    var onpress;
    if (_view == 0) {
      return Center(
              child: IconButton(
                  icon: Icon(Icons.play_circle_outline,size: 50),
                  color: Theme.of(ctx).accentIconTheme.color,
                  onPressed: () => openInApp()));
    } else if (_view == 1) {
      return Center(
              child: IconButton(
                  icon: Icon(Icons.play_circle_outline,size: 50),
                  color: Theme.of(ctx).accentIconTheme.color,
                  onPressed: () => openBrowser()));
    } else if (_view == 2) {
      if(_controller != null){
        _controller.loadUrl(url: _stream.link);
      }
        return _inApp;

    }
  }

  openInApp() {
    ChromeSafariBrowser().open(
        url: _stream.link,
        options: ChromeSafariBrowserClassOptions(
            android:
                AndroidChromeCustomTabsOptions(addShareButton: false),
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
