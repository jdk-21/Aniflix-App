import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/profile/Friend.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/listelements/iconListElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendList extends StatelessWidget implements Screen {
  int userid;
  Future<FriendListData> friendlistData;
  FriendListData data;
  Function refresh;

  FriendList(int userid, Function refresh) {
    this.userid = userid;
    this.friendlistData = APIManager.getUserFriends(userid);
    this.refresh = refresh;
  }

  @override
  getScreenName() {
    return "friendlist_screen";
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      key: Key("friendlist_screen"),
      color: Colors.transparent,
      child: FutureBuilder(
        future: friendlistData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            data = snapshot.data;
            return getLayout(ctx);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  getLayout(BuildContext ctx) {
    List<Widget> friendItems = [];
    ((CacheManager.userData.id == userid) &&
            ((data.friendlist.where((element) => (element.status == null)))
                    .length >
                0))
        ? friendItems.addAll(getFriendRequestsAsWidgets(ctx, data.friendlist))
        : Container();
    friendItems.addAll(getFriendsAsWidgets(ctx, data.friendlist));
    ((CacheManager.userData.id == userid) &&
            ((data.friendlist.where((element) => (element.status == 2)))
                    .length >
                0))
        ? friendItems.addAll(getBlockedFriendsAsWidgets(ctx, data.friendlist))
        : Container();

    return Container(
        padding: EdgeInsets.all(5),
        color: Colors.transparent,
        child: RefreshIndicator(
          child: ListView(
            children: friendItems,
          ),
          onRefresh: refresh,
        ));
  }

  List<Widget> getFriendsAsWidgets(BuildContext ctx, List<Friend> friendList) {
    List<Widget> friendlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child:
              ThemeText("Freunde", fontSize: 30, fontWeight: FontWeight.bold))
    ];

    for (var friend in friendList) {
      if (friend.status == 0) {
        Widget button = IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () {
            APIManager.cancelFriendRequest(friend.id);
            refresh();
          },
          color: Theme.of(ctx).primaryIconTheme.color,
        );

        friendlistWidget.add(IconListElement(
          (friend.user.id == userid) ? friend.friend.name : friend.user.name,
          (friend.user.id == userid)
              ? friend.friend.avatar
              : friend.user.avatar,
          ctx,
          button: (CacheManager.userData.id == userid) ? button : null,
          onTap: () {
            Navigator.pushNamed(ctx, "profil",
                arguments: (friend.user.id == userid)
                    ? friend.friend.id
                    : friend.user.id);
          },
        ));
      }
    }
    return friendlistWidget;
  }

  List<Widget> getFriendRequestsAsWidgets(
      BuildContext ctx, List<Friend> friendList) {
    List<Widget> friendlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Freundschaftsanfragen",
              fontSize: 30, fontWeight: FontWeight.bold)),
    ];
    ((data.friendlist.where((element) => (element.status == null && element.friend.id == userid))).length > 0) ?
    friendlistWidget
        .addAll(getIncomingFriendRequestsAsWidgets(ctx, friendList)) : Container();
    ((data.friendlist.where((element) => (element.status == null && element.user.id == userid))).length > 0) ?
    friendlistWidget
        .addAll(getOutgoingFriendRequestsAsWidgets(ctx, friendList)) : Container();
    return friendlistWidget;
  }

  List<Widget> getIncomingFriendRequestsAsWidgets(
      BuildContext ctx, List<Friend> friendList) {
    List<Widget> friendlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Eingehende",
              fontSize: 25, fontWeight: FontWeight.normal))
    ];

    for (var friend in friendList) {
      if (friend.status == null && friend.friend.id == userid) {
        Widget button = Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.check_circle_outline),
              onPressed: () async {
                APIManager.confirmFriendRequest(friend.id);
                refresh();
              },
              color: Theme.of(ctx).primaryIconTheme.color,
            ),
            IconButton(
              icon: Icon(Icons.highlight_off),
              onPressed: () async {
                APIManager.cancelFriendRequest(friend.id);
                refresh();
              },
              color: Theme.of(ctx).primaryIconTheme.color,
            ),
            IconButton(
              icon: Icon(Icons.block),
              onPressed: () async {
                APIManager.blockFriendRequest(friend.id);
                refresh();
              },
              color: Theme.of(ctx).primaryIconTheme.color,
            )
          ],
        );
        friendlistWidget.add(IconListElement(
          friend.user.name,
          friend.user.avatar,
          ctx,
          button: (CacheManager.userData.id == userid) ? button : null,
          onTap: () {
            Navigator.pushNamed(ctx, "profil", arguments: friend.user.id);
          },
        ));
      }
    }
    return friendlistWidget;
  }

  List<Widget> getOutgoingFriendRequestsAsWidgets(
      BuildContext ctx, List<Friend> friendList) {
    List<Widget> friendlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Ausgehende",
              fontSize: 25, fontWeight: FontWeight.normal))
    ];

    for (var friend in friendList) {
      if (friend.status == null && friend.user.id == userid) {
        Widget button = IconButton(
          icon: Icon(Icons.highlight_off),
          onPressed: () async {
            APIManager.cancelFriendRequest(friend.id);
            refresh();
          },
          color: Theme.of(ctx).primaryIconTheme.color,
        );
        friendlistWidget.add(IconListElement(
          friend.friend.name,
          friend.friend.avatar,
          ctx,
          button: (CacheManager.userData.id == userid) ? button : null,
          onTap: () {
            Navigator.pushNamed(ctx, "profil", arguments: friend.friend.id);
          },
        ));
      }
    }
    return friendlistWidget;
  }

  List<Widget> getBlockedFriendsAsWidgets(
      BuildContext ctx, List<Friend> friendList) {
    List<Widget> friendlistWidget = [
      Container(
          padding: EdgeInsets.all(5),
          child: ThemeText("Blockierte Freunde",
              fontSize: 30, fontWeight: FontWeight.bold))
    ];
    for (var friend in friendList) {
      if (friend.status == 2) {
        friendlistWidget.add(IconListElement(
          (friend.user.id == userid) ? friend.friend.name : friend.user.name,
          (friend.user.id == userid)
              ? friend.friend.avatar
              : friend.user.avatar,
          ctx,
          onTap: () {
            Navigator.pushNamed(ctx, "profil",
                arguments: (friend.user.id == userid)
                    ? friend.friend.id
                    : friend.user.id);
          },
        ));
      }
    }
    return friendlistWidget;
  }
}
