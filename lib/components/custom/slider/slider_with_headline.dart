import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../slider/carousel/AnimeCarousel.dart';
import '../../slider/SliderElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class HeadlineSlider extends StatelessWidget {
  String title;
  List<SliderElement> elements;
  double height;
  double size;

  HeadlineSlider(this.title, this.elements, this.height, {this.size = 0.6}) {
    elements.removeWhere((element) => element == null);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
        key: Key(title.replaceAll(" ", "_").toLowerCase()),
        padding: EdgeInsets.only(bottom: 20),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(left: 5, bottom: 5),
              alignment: AlignmentDirectional.topStart,
              child: ThemeText(
                title,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              )),
          AnimeCarousel(elements, height, size: size)
        ]));
  }
}
