import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../slider/carousel/AnimeCarousel.dart';
import '../../slider/SliderElement.dart';

class HeadlineSlider extends Container {
  String title;
  List<SliderElement> elements;
  double aspectRatio;
  HeadlineSlider(this.title, BuildContext ctx, this.elements,{this.aspectRatio = 200/110, double size = 0.6})
      : super(
    padding: EdgeInsets.only(bottom: 20),
            child: Column(children: [
          Container(
            margin: EdgeInsets.only(left: 5,bottom: 5),
            alignment: AlignmentDirectional.topStart,
              child: Text(
            title,
            style: TextStyle(
              color: Theme.of(ctx).textTheme.title.color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
          AnimeCarousel(elements,aspectRatio: aspectRatio, size: size),
        ]));
}
