import 'package:carousel_slider/carousel_slider.dart';
import '../SliderElement.dart';

class AnimeCarousel extends CarouselSlider{

  AnimeCarousel(List<SliderElement> data, {double size = 0.6}):super(
    aspectRatio: 200/110 / size,
    items: data,
    enlargeCenterPage: true,
    viewportFraction: size
  );

}