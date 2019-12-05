import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class AnimePlayer extends StatelessWidget {
  AnimeStream _stream;

  AnimePlayer(this._stream);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(10),
      child: (_stream.hoster.name == "Anistream" || _stream.hoster.name == "Fembed")
          ? InAppWebView(
              initialHeaders: {},
              initialOptions: {},
              onWebViewCreated: (InAppWebViewController controller) {
                controller.loadUrl(_stream.link);
              })
          : Center(
              child: IconButton(
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: () =>
                      ChromeSafariBrowser(null).open(_stream.link))),
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: Theme.of(ctx).textTheme.title.color)),
      height: 200,
    );
  }
}
