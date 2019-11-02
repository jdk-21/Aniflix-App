import 'package:flutter/material.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';
import '../navigationbars/mainbar.dart';
import 'package:aniflix_app/api/objects/LoginResponse.dart';

class Homedata{
  List<SliderElement> continues;
  List<SliderElement> airings;
  List<SliderElement> newshows;
  List<SliderElement> discover;

  Homedata(this.continues,this.airings,this.newshows,this.discover);
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
              color: Theme.of(ctx).backgroundColor,
              child: ListView(padding: EdgeInsets.only(top: 10), children: [
                HeadlineSlider("Weitersehen",ctx, snapshot.data.continues),
                HeadlineSlider("Neue Folgen",ctx, snapshot.data.airings),
                HeadlineSlider("Neu auf Aniflix",ctx, snapshot.data.newshows, aspectRatio: 200/300, size: 0.4,),
                HeadlineSlider("Entdecken",ctx, snapshot.data.discover, aspectRatio: 200/300, size: 0.4,),
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
