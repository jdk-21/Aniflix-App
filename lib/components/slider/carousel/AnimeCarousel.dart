import 'package:carousel_slider/carousel_slider.dart';
import '../SliderElement.dart';

class AnimeCarousel extends CarouselSlider{

  AnimeCarousel(List<SliderElement> data):super(
    aspectRatio: 16/9,
    items: data,
  );

}