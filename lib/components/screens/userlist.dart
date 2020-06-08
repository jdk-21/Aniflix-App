import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/listelements/iconListElement.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class UserListData {
  List<User> users;

  UserListData(this.users);
}

class Userlist extends StatefulWidget implements Screen {
  @override
  getScreenName() {
    return "userlist_screen";
  }

  @override
  State<StatefulWidget> createState() => UserlistState();
}

class UserlistState extends State<Userlist> {
  Future<UserListData> userlistdata;
  UserListData cache;
  String filterText;
  int actualPage;
  List<User> filteredUserList;

  UserlistState() {
    if (CacheManager.userlistdata == null) {
      userlistdata = APIManager.getUserList();
    } else {
      cache = CacheManager.userlistdata;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (cache == null) {
      return Container(
        key: Key("userlist_screen"),
        color: Theme.of(ctx).backgroundColor,
        child: FutureBuilder(
          future: userlistdata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CacheManager.userlistdata = snapshot.data;
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
    } else {
      return getLayout(cache, ctx);
    }
  }

  getLayout(UserListData data, BuildContext ctx) {
    return Column(
      children: <Widget>[
        (AppState.adFailed)
            ? Container()
            : SizedBox(
                height: 50,
              ),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(5),
          color: Theme.of(ctx).backgroundColor,
          child: RefreshIndicator(
            child: ListView(
              children: getUserAsWidgets(ctx, data.users),
            ),
            onRefresh: () async {
              APIManager.getUserList().then((data) {
                setState(() {
                  CacheManager.userlistdata = data;
                  cache = data;
                });
              });
            },
          ),
        ))
      ],
    );
  }

  List<Widget> getUserAsWidgets(BuildContext ctx, List<User> userlist) {
    var controller = TextEditingController();
    var entriesPerPage = 50;
    initActualPage();
    List<Widget> userWidget =
        initUserWidget(entriesPerPage, userlist, controller, ctx);

    buildPage(userWidget, entriesPerPage, userlist, ctx);
    return userWidget;
  }

  initUserWidget(int entriesPerPage, List<User> userlist,
      TextEditingController controller, BuildContext ctx) {
    return [
      Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ThemeText("Userlist", fontSize: 30, fontWeight: FontWeight.bold),
            Row(
              children: <Widget>[
                getPreviousPageButton(ctx),
                Text(
                    "${actualPage} of ${getMaxPages(userlist.length, entriesPerPage)}",
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.caption.color)),
                getNextPageButton(entriesPerPage, userlist, ctx)
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                setState(() {
                  filterText = text;
                  actualPage = 1;
                  if (usesFilter()) {
                    applyFilter(filteredUserList, userlist);
                  }
                });
              },
              style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
              keyboardType: TextInputType.multiline,
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: 'Search..'),
              autofocus: true,
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: Theme.of(ctx).primaryIconTheme.color,
            onPressed: () {
              setState(() {
                filterText = controller.text;
                actualPage = 1;
                if (usesFilter()) {
                  applyFilter(filteredUserList, userlist);
                }
              });
            },
          )
        ],
      ),
    ];
  }

  initActualPage() {
    if (actualPage == null) {
      actualPage = 1;
    }
  }

  getNextPageButton(int entriesPerPage, List<User> userlist, BuildContext ctx) {
    return (canOpenNextPage(userlist.length, entriesPerPage))
        ? IconButton(
      icon: Icon(
        Icons.navigate_next,
        color: Theme.of(ctx).textTheme.caption.color,
      ),
      color: Theme.of(ctx).textTheme.caption.color,
      onPressed: () {
        setState(() {
          actualPage = actualPage + 1;
        });
      },
    )
        : IconButton(
      icon: Icon(
        Icons.navigate_next,
        color: Theme.of(ctx).backgroundColor,
      ),
      color: Theme.of(ctx).backgroundColor,
      onPressed: () {},
    );
  }

  getPreviousPageButton(BuildContext ctx) {
    return (actualPage > 1)
        ? IconButton(
      icon: Icon(
        Icons.navigate_before,
        color: Theme.of(ctx).textTheme.caption.color,
      ),
      color: Theme.of(ctx).textTheme.caption.color,
      onPressed: () {
        setState(() {
          actualPage = actualPage - 1;
        });
      },
    )
        : IconButton(
      icon: Icon(
        Icons.navigate_before,
        color: Theme.of(ctx).backgroundColor,
      ),
      color: Theme.of(ctx).backgroundColor,
      onPressed: () {},
    );
  }

  getMaxPages(int length, int entriesPerPage) {
    return ((filterText == null || filterText == "")
        ? (length / entriesPerPage).ceil()
        : (filteredUserList.length < entriesPerPage
            ? "1"
            : (filteredUserList.length / entriesPerPage).ceil()));
  }

  canOpenNextPage(int length, int entriesPerPage) {
    return actualPage <
        ((filterText == null || filterText == "")
            ? (length / entriesPerPage).ceil()
            : (filteredUserList.length < entriesPerPage
                ? 1
                : (filteredUserList.length / entriesPerPage).ceil()));
  }

  applyFilter(List<User> filteredUserList, List<User> userlist) {
    filteredUserList = [];
    for (var user in userlist) {
      if (user.name.toLowerCase().contains(filterText.toLowerCase())) {
        filteredUserList.add(user);
      }
    }
  }

  usesFilter() {
    return filterText != null && filterText != "";
  }

  addFilteredUsers(List<Widget> userWidget, int entriesPerPage,
      List<User> userlist, BuildContext ctx) {
    for (var user in userlist.getRange(
        ((actualPage - 1) * entriesPerPage),
        ((actualPage * entriesPerPage) > userlist.length
            ? userlist.length
            : (actualPage * entriesPerPage)))) {
      userWidget.add(IconListElement(
        user.name,
        user.avatar,
        ctx,
        onTap: () {
          Navigator.pushNamed(ctx, "profil", arguments: user.id);
        },
      ));
    }
  }

  addUnfilteredUsers(List<User> userlist) {
    for (var user in userlist) {
      if (user.name.toLowerCase().contains(filterText.toLowerCase())) {
        filteredUserList.add(user);
      }
    }
  }

  addWidgetsforPage(
      List<Widget> userWidget, int entriesPerPage, BuildContext ctx) {
    for (var user in filteredUserList.getRange(
        ((actualPage - 1) * entriesPerPage),
        ((actualPage * entriesPerPage) > filteredUserList.length
            ? filteredUserList.length
            : (actualPage * entriesPerPage)))) {
      userWidget.add(IconListElement(
        user.name,
        user.avatar,
        ctx,
        onTap: () {
          Navigator.pushNamed(ctx, "profil", arguments: user.id);
        },
      ));
    }
  }

  buildPage(List<Widget> userWidget, int entriesPerPage, List<User> userlist,
      BuildContext ctx) {
    if (usesFilter()) {
      addFilteredUsers(userWidget, entriesPerPage, userlist, ctx);
    } else {
      if (filteredUserList == null) {
        addUnfilteredUsers(userlist);
      }
      addWidgetsforPage(userWidget, entriesPerPage, ctx);
    }
  }
}
