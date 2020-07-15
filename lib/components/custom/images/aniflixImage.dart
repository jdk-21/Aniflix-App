import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AniflixImage extends Image {
  AniflixImage(
    String url, {
    double width,
    double height,
  }) : super(
            width: width,
            height: height,
            image: CachedNetworkImageProvider("https://www2.aniflix.tv/storage/" + url));
}
