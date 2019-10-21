import 'package:flutter/material.dart';
import '../slider/carousel/AnimeCarousel.dart';
import '../slider/SliderElement.dart';

class Home extends StatelessWidget {
  //Text('Home', style: TextStyle(fontSize: 24.0))
  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.only(top: 10),
        child: Column(children: [
      AnimeCarousel([
        SliderElement(
            name: "Vinland Saga",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderElement(
            name: "Fairy Gone",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ]),
      AnimeCarousel([
        SliderElement(
            name: "Vinland Saga",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderElement(
            name: "Fairy Gone",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ])
    ]));
  }
}
