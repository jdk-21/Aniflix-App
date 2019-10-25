import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../slider/carousel/AnimeCarousel.dart';
import '../../slider/SliderElement.dart';

class HeadlineSlider extends Container {
  String title;
  List<SliderElement> elements;

  HeadlineSlider(this.title, BuildContext ctx, this.elements)
      : super(
    padding: EdgeInsets.only(bottom: 20),
            child: Column(children: [
          Container(
            margin: EdgeInsets.only(left: 5,bottom: 5),
            alignment: AlignmentDirectional.topStart,
              child: Text(
            title,
            style: TextStyle(
              //text color
              color: Theme.of(ctx).textTheme.title.color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
          AnimeCarousel(elements),
        ]));
}
