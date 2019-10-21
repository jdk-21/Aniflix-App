import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../datatypes/component_data/slider/SliderData.dart';

class AnimeCarousel extends CarouselSlider{

  AnimeCarousel(List<SliderData> data):super(
    aspectRatio: 16/9,
    items: data,
  );

}