import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter/material.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';

class Homedata{
  List<SliderElement> airings;
  List<SliderElement> newshows;
  List<SliderElement> discover;

  Homedata(this.airings,this.newshows,this.discover);
}

class Home extends StatelessWidget {
  Future<List<SliderElement>> airings;

  Home(){
    this.airings = APIManager.getAirings();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(child: FutureBuilder<List<SliderElement>>(
      future: airings,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              color: Color.fromRGBO(15, 15, 19, 1),
              child: ListView(padding: EdgeInsets.only(top: 10), children: [
                HeadlineSlider("Neue Folgen", snapshot.data),
                HeadlineSlider("Neu auf Aniflix", [
                  SliderElement(
                      name: "Vinland Saga",
                      description: "",
                      image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
                  SliderElement(
                      name: "Fairy Gone",
                      description: "",
                      image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
                ]),
                HeadlineSlider("Entdecken", [
                  SliderElement(
                      name: "Vinland Saga",
                      description: "",
                      image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
                  SliderElement(
                      name: "Fairy Gone",
                      description: "",
                      image: "https://www2.aniflix.tv/storage/1555840247-2.jpg")
                ]),
                HeadlineSlider("Weitersehen", [
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
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    ),);
  }
}
