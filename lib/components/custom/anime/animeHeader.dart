import 'package:flutter/material.dart';
import '../../../api/objects/anime/Anime.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/custom/images/aniflixImage.dart';
import 'package:aniflix_app/components/screens/review.dart';
import 'package:aniflix_app/main.dart';

class AnimeHeader extends Container {
  AnimeHeader(
      Anime anime, int episodeCount, BuildContext ctx)
      : super(
            child: Row(children: [
          AniflixImage(
            anime.cover_portrait,
            width: 100,
            height: 150,
          ),
          Expanded(
            child: Column(
              children: [
                ThemeText(
                  anime.name,
                  fontWeight: FontWeight.bold,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                ThemeText(
                  "Score: " + anime.rating,
                  fontSize: 15,
                  textAlign: TextAlign.left,
                ),
                ThemeText(
                  "Status: " +
                      ((anime.airing != null) ? "Airing" : "Not Airing"),
                  fontSize: 15,
                  textAlign: TextAlign.left,
                ),
                ThemeText(
                  "Episoden: " + episodeCount.toString(),
                  fontSize: 15,
                  textAlign: TextAlign.left,
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(ctx).textTheme.caption.color))),
                    child: ThemeText("Reviews",
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pushNamed(ctx, "review",arguments: anime.url);
                  },
                ),
              ],
            ),
          ),
        ]));
}
