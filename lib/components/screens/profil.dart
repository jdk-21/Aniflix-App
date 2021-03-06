import 'package:aniflix_app/api/objects/profile/UserProfile.dart';
import 'package:aniflix_app/api/objects/profile/Friend.dart';
import 'package:aniflix_app/api/objects/profile/UserSettings.dart';
import 'package:aniflix_app/api/objects/profile/UserStats.dart';
import 'package:aniflix_app/api/requests/user/ProfileRequests.dart';
import 'package:aniflix_app/components/navigationbars/profilebar.dart';
import 'package:aniflix_app/components/screens/friendlist.dart';
import 'package:aniflix_app/components/screens/profileanimelist.dart';
import 'package:aniflix_app/components/screens/profilesettings.dart';
import 'package:aniflix_app/components/screens/profilesubbox.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/components/slider/TextboxSliderElement.dart';
import 'package:aniflix_app/components/custom/listelements/imageListElement.dart';
import 'package:aniflix_app/components/custom/anime/animeDescription.dart';
import 'package:aniflix_app/components/custom/slider/slider_with_headline.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:aniflix_app/components/slider/carousel/TextBoxCarousel.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/api/objects/profile/UserWatchlistData.dart';
import 'package:aniflix_app/api/objects/profile/UserSubData.dart';
import 'package:aniflix_app/components/screens/verlauf.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/components/screens/favoriten.dart';
import 'package:aniflix_app/components/screens/watchlist.dart';
import 'package:aniflix_app/components/custom/dialogs/aboutMeDialog.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class UserProfileData {
  UserProfile userProfile;
  UserStats userstats;
  Historydata historydata;
  Favouritedata favouritedata;
  UserSubData userSubData;
  UserWatchlistData userWatchlistData;
  FriendListData friendListData;

  UserProfileData(
      this.userProfile,
      this.userstats,
      this.historydata,
      this.favouritedata,
      this.userSubData,
      this.userWatchlistData,
      this.friendListData);
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
  int barIndex = 0;
  bool barInit = false;
  Future<UserProfileData> profileData;
  String aboutMe;
  PageController controller;
  UserSettings modifiedSettings;

  ProfileState(this.userID) {
    if (CacheManager.session != null) profileData = ProfileRequests.getUserProfileData(userID);
  }

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  setIndex(int value) {
    setState(() {
      barIndex = value;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    if (CacheManager.session == null) {
      return Center(child: ThemeText("Du musst dafür eingeloggt sein!"));
    }
    return Container(
      key: Key("profile_screen"),
      color: Colors.transparent,
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

  updateSettings() async {
    await ProfileRequests.updateSettings(this.modifiedSettings);
    setState(() {
      this.profileData = ProfileRequests.getUserProfileData(userID);
      controller.jumpToPage(controller.initialPage);
    });
  }

  updateAvatar() {
    setState(() {
      this.profileData = ProfileRequests.getUserProfileData(userID);
    });
  }

  getLayout(UserProfileData data, BuildContext ctx) {
    var profile = data.userProfile;
    if (modifiedSettings == null) {
      if (profile.settings != null) {
        modifiedSettings = new UserSettings.fromObject(profile.settings);
      } else {
        modifiedSettings = UserSettings(0, profile.id, true, true, true, true,
            true, null, null, null, null, null, null);
      }
    }
    var joined = DateTime.parse(profile.created_at);
    if (aboutMe != null) {
      data.userProfile.about_me = aboutMe;
    }
    var isAlreadyFriend = false;
    for (var friend in data.friendListData.friendlist) {
      var id = (friend.user.id == userID) ? friend.friend.id : friend.user.id;
      if (id == CacheManager.userData.id) {
        isAlreadyFriend = true;
      }
    }

    List<Widget> pages = [
      ProfileMainPage(data, () {
        showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return AboutMeDialog((text) {
                ProfileRequests.updateAboutMe(text);
                setState(() {
                  if (text == null) {
                    aboutMe = "";
                  } else {
                    aboutMe = text;
                  }
                });
              });
            });
      }),
    ];
    List<TitledNavigationBarItem> items = [];
    /*items.add(TitledNavigationBarItem(
        icon: Icons.person,
        title: ThemeText('Profil'),
        backgroundColor: Theme.of(ctx).backgroundColor));*/
    if (data.userProfile.settings == null ||
        data.userProfile.settings.show_friends) {
      pages.add(FriendList(userID, () {
        setState(() {
          profileData = ProfileRequests.getUserProfileData(userID);
        });
      }));
      items.add(TitledNavigationBarItem(
          icon: Icons.group,
          title: ThemeText('Freunde'),
          backgroundColor: Theme.of(ctx).backgroundColor));
    }

    if (data.userProfile.settings == null ||
        data.userProfile.settings.show_favorites) {
      pages.add(Favoriten(favouritedata: data.favouritedata));
      items.add(TitledNavigationBarItem(
          icon: Icons.favorite,
          title: ThemeText('Favoriten'),
          backgroundColor: Theme.of(ctx).backgroundColor));
    }

    if (data.userProfile.settings == null ||
        data.userProfile.settings.show_abos) {
      pages.add(ProfileSubBox(userID));
      items.add(TitledNavigationBarItem(
          icon: Icons.subscriptions,
          title: ThemeText('Abos'),
          backgroundColor: Theme.of(ctx).backgroundColor));
    }

    if (data.userProfile.settings == null ||
        data.userProfile.settings.show_watchlist) {
      pages.add(Watchlist(
        watchlistdata: data.userWatchlistData,
      ));
      items.add(TitledNavigationBarItem(
          icon: Icons.watch_later,
          title: ThemeText('Watchlist'),
          backgroundColor: Theme.of(ctx).backgroundColor));
    }

    if (data.userProfile.settings == null ||
        data.userProfile.settings.show_list) {
      pages.add(ProfileAnimeList(userID));
      items.add(TitledNavigationBarItem(
          icon: Icons.list,
          title: ThemeText('Anime Liste'),
          backgroundColor: Theme.of(ctx).backgroundColor));
    }
    List<TextboxSliderElement> carouseldata = profile.groups
        .map((group) => TextboxSliderElement(group.name))
        .toList();

    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: (CacheManager.userData.id == userID)
            ? FloatingActionButton(
                heroTag: null,
                backgroundColor: Theme.of(ctx).iconTheme.color,
                onPressed: () {
                  showSettings();
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              )
            : null,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                                "https://www2.aniflix.tv/storage/" +
                                    profile.avatar,
                              ),
                            ))),
                            onPressed: () {}),
                    ThemeText(profile.name),
                    (CacheManager.userData.id == userID || isAlreadyFriend)
                        ? Container()
                        : IconButton(
                            icon: Icon(Icons.person_add),
                            onPressed: () {
                              ProfileRequests.addFriend(profile.id);
                              setState(() {
                                profileData =
                                    ProfileRequests.getUserProfileData(userID);
                              });
                            },
                            color: Theme.of(ctx).primaryIconTheme.color,
                          ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        TextboxSliderElement(
                          "Mitglied seit " +
                              joined.day.toString() +
                              "." +
                              joined.month.toString() +
                              "." +
                              joined.year.toString(),
                        ),
                        TextboxSliderElement(
                            "Punkte: " + data.userstats.points.toString()),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          child: TextboxCarousel(carouseldata),
                          width: MediaQuery.of(ctx).size.width * 0.75,
                        )
                      ],
                    )
                  ],
                ),
                Container()
              ],
            ),
            TextboxSliderElement("Anime geschaut: " + data.userstats.time),
            SizedBox(
              height: 5,
            ),
            Expanded(
                child: PageView(
                    controller: controller,
                    children: pages,
                    onPageChanged: (value) => setIndex(value)))
          ],
        ),
        bottomNavigationBar:
            AniflixProfilebar(barIndex, controller, items, ctx, this));
  }

  showSettings() {
    Scaffold.of(context).showBottomSheet<Widget>((ctx) {
      return Container(
          height: MediaQuery.of(ctx).size.height / 2,
          color: Theme.of(ctx).backgroundColor,
          child: ProfileSettings(modifiedSettings, updateAvatar, (newData) {
            setState(() {
              this.modifiedSettings = newData;
            });
          }, () {
            updateSettings();
          }));
    });
  }
}

class ProfileMainPage extends StatelessWidget {
  UserProfileData _userProfileData;
  Function _onPressed;

  ProfileMainPage(this._userProfileData, this._onPressed);

  @override
  Widget build(BuildContext ctx) {
    var profile = _userProfileData.userProfile;
    if (profile.about_me == null) {
      profile.about_me = "";
    }
    var minLenght = 30;
    var widgets = <Widget>[
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          ThemeText("Über mich:"),
          (_userProfileData.userProfile.id == CacheManager.userData.id)
              ? IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(ctx).primaryIconTheme.color),
                  onPressed: _onPressed,
                )
              : Container()
        ],
      ),
      (profile.about_me.length < minLenght)
          ? SizedBox(
              height: 5,
            )
          : Container(),
      (profile.about_me.length < minLenght)
          ? ThemeText(
              profile.about_me,
              fontSize: 15,
            )
          : AnimeDescription(profile.about_me, ctx),
      SizedBox(
        height: 10,
      ),
    ];

    if (profile.settings == null || profile.settings.show_favorites) {
      widgets.addAll([
        ThemeText("Lieblings Anime:"),
        SizedBox(
          height: 5,
        ),
      ]);

      var count = 0;
      for (var anime in profile.favorites) {
        if (count >= 3) {
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
    }

    var history = <SliderElement>[];
    for (var episode in _userProfileData.historydata.episodes) {
      var desc = "";
      var date = DateTime.parse(episode.created_at);
      desc = date.day.toString() +
          "." +
          date.month.toString() +
          "." +
          date.year.toString();
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
            Navigator.pushNamed(ctx, "episode",
                arguments: EpisodeScreenArguments(episode.season.show.url,
                    episode.season.number, episode.number));
          }));
    }
    widgets.addAll([
      Container(
        child: SizedBox(
          height: 15,
        ),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1, color: Theme.of(ctx).textTheme.caption.color))),
      ),
      HeadlineSlider("Zuletzt gesehen:", history, 350)
    ]);

    return ListView(children: widgets);
  }
}
