import 'package:carousel_slider/carousel_slider.dart';
import '../SliderElement.dart';

class AnimeCarousel extends CarouselSlider{

  AnimeCarousel(List<SliderElement> data):super(
    aspectRatio: 200/110,
    items: data,
  );

}