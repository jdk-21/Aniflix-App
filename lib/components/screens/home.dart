import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../slider/SliderElement.dart';
import '../custom/slider/slider_with_headline.dart';
import '../../api/APIManager.dart';

class Homedata {
  List<SliderElement> continues;
  List<SliderElement> airings;
  List<SliderElement> newshows;
  List<SliderElement> discover;

  Homedata(this.continues, this.airings, this.newshows, this.discover);
}

class Home extends StatefulWidget implements Screen {
  Home();

  @override
  getScreenName() {
    return "home_screen";
  }

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<Homedata> homedata;
  Homedata cache;
  NativeAd ad;

  HomeState() {
    ad = new NativeAd(adUnitId: NativeAd.testAdUnitId, factoryId: 'adFactoryExample',targetingInfo: App.targetingInfo,listener: (MobileAdEvent event) {
      print("$NativeAd event $event");
    });
    if (CacheManager.homedata == null) {
      this.homedata = APIManager.getHomeData((continues) {
        setState(() {
          CacheManager.homedata.continues = continues;
          this.cache.continues = continues;
        });
      });
    } else {
      cache = CacheManager.homedata;
    }
    
    
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null) {
      return Container(
        key: Key("home_screen"),
        color: Theme.of(ctx).backgroundColor,
        child: FutureBuilder<Homedata>(
          future: homedata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CacheManager.homedata = snapshot.data;
              return getLayout(ctx, snapshot.data);
            } else if (snapshot.hasError) {
              return ThemeText("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Container(
          key: Key("home_screen"),
          color: Theme.of(ctx).backgroundColor,
          child: getLayout(ctx, cache));
    }
  }

  getLayout(BuildContext ctx, Homedata data) {
    return Column(children: <Widget>[
          (AppState.adFailed) ? Container() : SizedBox(height: 50,),
      Expanded(child: Container(
        color: Theme.of(ctx).backgroundColor,
        child: RefreshIndicator(
          child: ListView(padding: EdgeInsets.only(top: 10), children: [
            
            (data.continues.length > 0)
                ? HeadlineSlider("Weitersehen", data.continues)
                : Container(),
            HeadlineSlider("Neue Folgen", data.airings),
            HeadlineSlider(
              "Neu auf Aniflix",
              data.newshows,
              aspectRatio: 200 / 300,
              size: 0.4,
            ),
            HeadlineSlider(
              "Entdecken",
              data.discover,
              aspectRatio: 200 / 300,
              size: 0.4,
            ),
          ]),
          onRefresh: () async {
            setState(() {
              APIManager.getHomeData((continues) {
                setState(() {
                  CacheManager.homedata.continues = continues;
                  this.cache.continues = continues;
                });
              }).then((data) {
                CacheManager.homedata = data;
                setState(() {
                  cache = data;
                });
              });
            });
          },
        ))
      )

    ],);
  }
}
