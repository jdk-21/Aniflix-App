import 'package:flutter/material.dart';
import '../slider/carousel/AnimeCarousel.dart';
import '../../datatypes/component_data/slider/SliderData.dart';

class Home extends StatelessWidget {
  //Text('Home', style: TextStyle(fontSize: 24.0))
  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.only(top: 10),
        child: Column(children: [
      AnimeCarousel([
        SliderData(
            name: "Vinland Saga",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderData(
            name: "Fairy Gone",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ]),
      AnimeCarousel([
        SliderData(
            name: "Vinland Saga",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderData(
            name: "Fairy Gone",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ])
    ]));
  }
}
