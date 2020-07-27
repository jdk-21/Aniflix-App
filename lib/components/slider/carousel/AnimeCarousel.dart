import 'package:carousel_slider/carousel_slider.dart';
import '../SliderElement.dart';

class AnimeCarousel extends CarouselSlider {
  AnimeCarousel(List<SliderElement> data, double height, {double size = 0.6})
      : super(
          items: data,
          options: CarouselOptions(
              height: height,
              viewportFraction: size,
              enableInfiniteScroll: false,
              reverse: false,
              initialPage: (data.length > 1) ? 1 : 0),
        );
}
