import 'package:flutter/material.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Container(
      color: Theme.of(ctx).backgroundColor,
        child: ListView(padding: EdgeInsets.only(top: 10), children: [
      HeadlineSlider("Neue Folgen", ctx, [
        SliderElement(
            name: "Vinland Saga",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderElement(
            name: "Fairy Gone",
            description: "Gestern",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ]),
      HeadlineSlider("Neu auf Aniflix", ctx, [
        SliderElement(
            name: "Vinland Saga",
            description: "",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderElement(
            name: "Fairy Gone",
            description: "",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ]),
      HeadlineSlider("Entdecken", ctx, [
        SliderElement(
            name: "Vinland Saga",
            description: "",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderElement(
            name: "Fairy Gone",
            description: "",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ]),
      HeadlineSlider("Weitersehen", ctx, [
        SliderElement(
            name: "Vinland Saga",
            description: "S01E02",
            image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
        SliderElement(
            name: "Fairy Gone",
            description: "S02E01",
            image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
      ]),
    ]));
  }
}
