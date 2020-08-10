import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import '../SliderElement.dart';

class AnimeCarousel extends StatelessWidget {
  List<SliderElement> data;
  double height;
  double size;

  AnimeCarousel(this.data, this.height, {this.size = 0.6});

  @override
  Widget build(BuildContext ctx) {
    return CarouselSlider(
      items: data,
      options: CarouselOptions(
          height: height,
          viewportFraction: size,
          enableInfiniteScroll: false,
          reverse: false,
          initialPage: (data.length > 1) ? 1 : 0),
    );
  }
}
