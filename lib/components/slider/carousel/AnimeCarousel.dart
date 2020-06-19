import 'package:aniflix_app/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../SliderElement.dart';

class AnimeCarousel extends CarouselSlider{

  AnimeCarousel(List<SliderElement> data, {double size = 0.6, double aspectRatio = 200/110}):super(
    aspectRatio: aspectRatio / size,
      items: data,
      viewportFraction: size,
      enableInfiniteScroll: false,
      reverse: false,
      initialPage: isDesktop()?((aspectRatio == 200/110)?(data.length > 2)? 2 : 0 : (data.length > 3)? 3 : 0):((data.length > 1)? 1 : 0)
  );

}