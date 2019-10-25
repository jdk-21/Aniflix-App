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
  Future<Homedata> homedata;
  Home(){
    this.homedata = APIManager.getHomeData();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(child: FutureBuilder<Homedata>(
      future: homedata,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              color: Color.fromRGBO(15, 15, 19, 1),
              child: ListView(padding: EdgeInsets.only(top: 10), children: [
                HeadlineSlider("Neue Folgen", snapshot.data.airings),
                HeadlineSlider("Neu auf Aniflix", snapshot.data.newshows, aspectRatio: 200/300, size: 0.4,),
                HeadlineSlider("Entdecken", snapshot.data.discover, aspectRatio: 200/300, size: 0.4,),
                HeadlineSlider("Weitersehen", [
                  SliderElement(
                      name: "Vinland Saga",
                      description: "Work in Progress!",
                      image: "https://www2.aniflix.tv/storage/1561791773-2.jpg"),
                  SliderElement(
                      name: "Fairy Gone",
                      description: "Work in Progress!",
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
