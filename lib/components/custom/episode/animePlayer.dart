import 'dart:io';

import 'package:aniflix_app/api/objects/episode/EpisodeInfo.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/Stream.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimePlayerController {
  EpisodeInfo episode;
  AnimeStream stream;
  int view;
  AnimePlayerState state;
  EpisodeScreenState episodeScreenState;

  AnimePlayerController(
      this.episode, this.stream, this.view, this.episodeScreenState);

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
  bool _changeStream;
  final AnimePlayerController _controller;
  InAppWebViewController _webcontroller;
  Widget _inApp;

  AnimePlayerState(this._controller) {
    this._stream = _controller.stream;
    this._view = _controller.view;
    this._changeStream = true;
    if (_controller.state == null) {
      _controller.state = this;
    }
  }

  setStream(AnimeStream stream) {
    setState(() {
      this._stream = stream;
      _changeStream = true;
    });
  }

  setView(int view) {
    setState(() {
      this._view = view;
      _changeStream = true;
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
      height: _view == 2 ? 300 : 200,
      width: MediaQuery.of(ctx).size.width - 50,
    );
  }

  Widget getPlayer(BuildContext ctx) {
    if (_view == 0) {
      _changeStream = false;
      return Center(
          child: IconButton(
              icon: Icon(Icons.play_circle_outline, size: 50),
              color: Theme.of(ctx).accentIconTheme.color,
              onPressed: () => openInApp()));
    } else if (_view == 1) {
      _changeStream = false;
      return Center(
          child: IconButton(
              icon: Icon(Icons.play_circle_outline, size: 50),
              color: Theme.of(ctx).accentIconTheme.color,
              onPressed: () => openBrowser()));
    } else if (_view == 2) {
      if (!_changeStream && _inApp != null) {
        return _inApp;
      }
      _changeStream = false;
      if (HosterParser.parser.containsKey(_stream.hoster_id)) {
        return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var source = snapshot.data;
                _inApp = Column(
                  children: [
                    Expanded(
                        child: InAppWebView(
                            initialOptions: InAppWebViewGroupOptions(),
                            initialUrl: source,
                            onWebViewCreated: (controller) => setState(() {
                                  _webcontroller = controller;
                                }))),
                    (HosterParser.parser[_stream.hoster_id].canDownload)
                        ? FlatButton(
                            onPressed: () {
                              RewardedVideoAd.instance.show();
                              RewardedVideoAd.instance.listener =
                                  (RewardedVideoAdEvent event,
                                      {String rewardType, int rewardAmount}) {
                                print(event);
                                if (event == RewardedVideoAdEvent.rewarded ||
                                    event ==
                                        RewardedVideoAdEvent.failedToLoad) {
                                  print("Start Download");
                                  startDownload(source, ctx);
                                }
                              };
                            },
                            child: ThemeText("Download nach Werbung"),
                            color: Theme.of(ctx).backgroundColor)
                        : Container()
                  ],
                );
                return _inApp;
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
    return Center(child: ThemeText("Player konnte nicht geladen werden!"));
  }

  startDownload(String source, BuildContext context) async {
    var path = await findLocalPath(_controller.episode, context);
    if (!Directory(path).existsSync()) {
      bool hasPerm = await SimplePermissions.checkPermission(
          Permission.WriteExternalStorage);
      if (!hasPerm) {
        PermissionStatus permissionResult =
            await SimplePermissions.requestPermission(
                Permission.WriteExternalStorage);
        print(permissionResult.toString());
        if (!(permissionResult == PermissionStatus.authorized)) {
          return;
        }
      }
      Directory(path).createSync(recursive: true);
    }
    print("Path: " + path);
    FlutterDownloader.enqueue(
        url: source,
        savedDir: path,
        showNotification: true,
        openFileFromNotification: true);
  }

  static Future<String> findLocalPath(
      EpisodeInfo episode, BuildContext context) async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    var path = directory.path +
        "/" +
        episode.season.show.name +
        "/Season/" +
        episode.season.number.toString() +
        "/Episode/" +
        episode.number.toString() +
        "/";
    return path;
  }

  openInApp() {
    ChromeSafariBrowser().open(
        url: _stream.link,
        options: ChromeSafariBrowserClassOptions(
            android: AndroidChromeCustomTabsOptions(),
            ios: IOSSafariOptions()));
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
