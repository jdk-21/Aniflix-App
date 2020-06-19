import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../slider/carousel/AnimeCarousel.dart';
import '../../slider/SliderElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class HeadlineSlider extends StatelessWidget {
  String title;
  List<SliderElement> elements;
  double aspectRatio;
  double size;

  HeadlineSlider(this.title, this.elements,
      {this.aspectRatio = 200 / 110, this.size = 0.6})
      : super();

  @override
  Widget build(BuildContext ctx) {
    return Container(
        key: Key(title.replaceAll(" ", "_").toLowerCase()),
        padding: EdgeInsets.only(bottom: 20),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(left: 5, bottom: 5),
              alignment: AlignmentDirectional.topStart,
              child: ThemeText(title, fontWeight: FontWeight.bold)),
          isDesktop()?
          AnimeCarousel(elements, aspectRatio: aspectRatio, size: size / 3.5,):
          (MediaQuery.of(ctx).orientation == Orientation.portrait?
          AnimeCarousel(elements, aspectRatio: aspectRatio, size: size):
          AnimeCarousel(elements, aspectRatio: aspectRatio, size: size / 2))
        ]));
  }
}
