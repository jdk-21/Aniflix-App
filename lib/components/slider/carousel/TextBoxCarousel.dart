import 'package:aniflix_app/components/slider/TextboxSliderElement.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TextboxCarousel extends CarouselSlider {
  TextboxCarousel(
    List<TextboxSliderElement> data, {
    double size = 0.3,
  }) : super(
          options: CarouselOptions(
            height: 35,
            enlargeCenterPage: true,
            viewportFraction: size,
            enableInfiniteScroll: false,
          ),
          items: data,
        );
}
