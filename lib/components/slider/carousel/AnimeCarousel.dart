import 'package:carousel_slider/carousel_slider.dart';
import '../SliderElement.dart';

class AnimeCarousel extends CarouselSlider{

  AnimeCarousel(List<SliderElement> data, {double size = 0.6, double aspectRatio = 200/110}):super(
    aspectRatio: aspectRatio / size,
      items: data,
      enlargeCenterPage: true,
      viewportFraction: size,
      enableInfiniteScroll: false,
      reverse: false,
      initialPage: (data.length > 1)? 1 : 0
  );

}