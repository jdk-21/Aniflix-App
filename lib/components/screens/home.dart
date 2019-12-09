import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';
import '../../main.dart';

class Homedata{
  List<SliderElement> continues;
  List<SliderElement> airings;
  List<SliderElement> newshows;
  List<SliderElement> discover;

  Homedata(this.continues,this.airings,this.newshows,this.discover);
}

class Home extends StatefulWidget implements Screen{
  MainWidgetState state;

  Home(this.state);


  @override
  getScreenName() {
    return "home_screen";
  }

  @override
  HomeState createState() => HomeState(state);
}

class HomeState extends State<Home>{

  Future<Homedata> homedata;
  List<SliderElement> continues = [];

  HomeState(MainWidgetState state){
    this.homedata = APIManager.getHomeData(state, (continues){setState(() {
      this.continues = continues;
    });});
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("home_screen"),
      child: FutureBuilder<Homedata>(
      future: homedata,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              color: Theme.of(ctx).backgroundColor,
              child: ListView(padding: EdgeInsets.only(top: 10), children: [
                (continues.length < 1) ? ((snapshot.data.continues.length > 0) ? HeadlineSlider("Weitersehen",ctx, snapshot.data.continues):Container()) : HeadlineSlider("Weitersehen",ctx, continues),
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
