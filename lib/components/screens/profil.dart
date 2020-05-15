import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/profile/UserProfile.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/components/slider/TextboxSliderElement.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/custom/anime/animeDescription.dart';
import 'package:aniflix_app/components/custom/slider/slider_with_headline.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/profile/UserWatchlistData.dart';
import 'package:aniflix_app/api/objects/profile/UserSubData.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';

class UserProfileData{

  UserProfile userProfile;
  Historydata historydata;
  Favouritedata favouritedata;
  UserSubData userSubData;
  UserWatchlistData userWatchlistData;

  UserProfileData(this.userProfile,this.historydata,this.favouritedata,this.userSubData,this.userWatchlistData);
}

class Profile extends StatefulWidget implements Screen {
  int userID;

  Profile(this.userID);

  @override
  getScreenName() {
    return "profile_screen";
  }

  @override
  State<StatefulWidget> createState() => ProfileState(userID);
}

class ProfileState extends State<Profile> {
  int userID;
  Future<UserProfileData> profileData;

  ProfileState(this.userID) {
    profileData = APIManager.getUserProfileData(userID);
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("profile_screen"),
      color: Theme.of(ctx).backgroundColor,
      child: FutureBuilder<UserProfileData>(
        future: profileData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return getLayout(snapshot.data, ctx);
          } else if (snapshot.hasError) {
            return Container(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text("${snapshot.error}",
                      style: TextStyle(
                          color: Theme.of(ctx).textTheme.caption.color))
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  getLayout(UserProfileData data, BuildContext ctx) {
    var profile = data.userProfile;
    var joined = DateTime.parse(profile.created_at);
    return Column(children: [
      (AppState.adFailed) ? Container() : SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (profile.avatar == null)
              ? IconButton(
            iconSize: 50,
            icon: Icon(
              Icons.person,
              color: Theme.of(ctx).primaryIconTheme.color,
            ),
            onPressed: () {},
          )
              : IconButton(
              iconSize: 50,
              icon: new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "https://www2.aniflix.tv/storage/" + profile.avatar,
                        ),
                      ))),
              onPressed: () {}),
          Column(children: [
            ThemeText(profile.name, ctx),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (profile.groups.length > 0)
                    ? TextboxSliderElement(profile.groups[0].name)
                    : Container(),
                TextboxSliderElement(
                  "Mitglied seit " +
                      joined.day.toString() +
                      "." +
                      joined.month.toString() +
                      "." +
                      joined.year.toString(),
                )
              ],
            )
          ],),
          Container()
        ],
      ),
      Expanded(child:  PageView(controller: PageController(initialPage: 0),children: [ProfileMainPage(data),Favoriten(favouritedata: data.favouritedata),Watchlist(watchlistdata: data.userWatchlistData,)]))

    ],);
  }
}

class ProfileMainPage extends StatelessWidget{

  UserProfileData _userProfileData;

  ProfileMainPage(this._userProfileData);

  @override
  Widget build(BuildContext ctx) {
    var profile = _userProfileData.userProfile;
    var widgets = <Widget>[
      SizedBox(height: 10,),
      ThemeText("Über mich:", ctx),
      SizedBox(height: 5,),
      (profile.about_me.length < 20)?ThemeText(profile.about_me,ctx,fontSize: 15,):AnimeDescription(profile.about_me, ctx),
      SizedBox(height: 10,),
      ThemeText("Lieblings Anime:", ctx),
      SizedBox(height: 5,),
    ];
    var count = 0;
    for (var anime in profile.favorites) {
      if(count >= 3){
        break;
      }
      widgets.add(ImageListElement(
        anime.name,
        anime.cover_portrait,
        ctx,
        onTap: () {
          Navigator.pushNamed(ctx, "anime", arguments: anime.url);
        },
      ));
      count++;
    }
    var history = <SliderElement>[];
    for(var episode in _userProfileData.historydata.episodes){
      var desc = "";
      var date = DateTime.parse(episode.created_at);
      desc = date.day.toString()+"."+date.month.toString()+"."+date.year.toString();
      history.add(SliderElement(
          name: episode.season.show.name +
              " S" +
              episode.season.number.toString() +
              "E" +
              episode.number.toString(),
          description: desc,
          image: "https://www2.aniflix.tv/storage/" +
              episode.season.show.cover_landscape,
          onTap: (ctx) {
            Navigator.pushNamed(ctx, "episode", arguments: EpisodeScreenArguments(episode.season.show.url,episode.season.number, episode.number));
          }));
    }
    widgets.addAll([
      Container(child: SizedBox(height: 15,),decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: Theme.of(ctx).textTheme.caption.color))),),
      HeadlineSlider("Zuletzt gesehen:",history)
    ]
    );

    return ListView(children: widgets);
  }

}
