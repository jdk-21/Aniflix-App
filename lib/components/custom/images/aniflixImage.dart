import 'package:flutter/material.dart';

class AniflixImage extends Image {
  AniflixImage(
    String url, {
    double width,
    double height,
  }) : super(
            width: width,
            height: height,
            image: NetworkImage("https://www2.aniflix.tv/storage/" + url));
}
