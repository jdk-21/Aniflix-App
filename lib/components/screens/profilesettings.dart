import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/objects/profile/UserSettings.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/checkbox/SettingsCheckbox.dart';
import 'package:aniflix_app/components/screens/profil.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class ProfileSettings extends StatelessWidget implements Screen {
  UserSettings data;
  Function(UserSettings) onSettingsChange;
  Function onSave;

  ProfileSettings(this.data, this.onSettingsChange, this.onSave) {
    if (CacheManager.userlistdata == null) {
      APIManager.getUserList().then((data) {
        CacheManager.userlistdata = data;
      });
    }
  }

  @override
  getScreenName() {
    return "profilesettings_screen";
  }

  final usernameController = TextEditingController();
  final passwortController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return new Container(
        color: Theme.of(ctx).backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(5),
              child: ThemeText(
                "Settings",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(ctx).textTheme.caption.color))),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15),
                  buildButtons("Change Username", () {
                    showChangeDialog(
                        ctx,
                        "Change Username",
                        TextField(
                            style: TextStyle(
                                color: Theme.of(ctx).textTheme.caption.color),
                            controller: usernameController,
                            decoration: InputDecoration(
                                hintText: "neuer Username",
                                hintStyle: TextStyle(
                                    color: Theme.of(ctx).hintColor,
                                    fontSize: 15),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(ctx).hintColor)))),
                        "Speichern", () {
                      if (usernameController.value.text == "") {
                        showErrorDialog(
                            ctx, "Der neue Username muss Zeichen enthalten.");
                      } else {
                        var a = (CacheManager.userlistdata.users.where(
                            (element) => (element.name
                                    .toLowerCase()
                                    .compareTo(usernameController.value.text) ==
                                0)));
                        if (a.length > 0) {
                          showErrorDialog(ctx,
                              "Dieser Username existiert bereits. Bitte wähle einen anderen.");
                        } else {
                          APIManager.updateName(usernameController.value.text);
                          CacheManager.userData.name =
                              usernameController.value.text;
                          resetTextController();
                          Navigator.of(ctx).pop();
                        }
                      }
                    });
                  }, ctx),
                  SizedBox(height: 5),
                  buildButtons("Change Password", () {
                    showChangeDialog(
                        ctx,
                        "Change Password",
                        TextField(
                            style: TextStyle(
                                color: Theme.of(ctx).textTheme.caption.color),
                            controller: passwortController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "neues Passwort",
                                hintStyle: TextStyle(
                                    color: Theme.of(ctx).hintColor,
                                    fontSize: 15),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(ctx).hintColor)))),
                        "Speichern", () {
                      if (passwortController.value.text == "") {
                        showErrorDialog(
                            ctx, "Das neue Passwort muss Zeichen enthalten.");
                      } else {
                        APIManager.updatePassword(CacheManager.userData.id,
                            passwortController.value.text);
                        resetTextController();
                        Navigator.of(ctx).pop();
                      }
                    });
                  }, ctx),
                  SizedBox(height: 5),
                  getSettingsLayout(ctx),
                  buildButtons("Save Settings", onSave, ctx)
                ],
              ),
            ),
          ],
        ));
  }

  Widget getSettingsLayout(BuildContext ctx) {
    return Row(
      children: [
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsCheckbox("Abos Öffentlich anzeigen", (newVal) {
                  data.show_abos = newVal;
                  onSettingsChange(data);
                }, value: data.show_abos),
                SettingsCheckbox("Favoriten öffentlich anzeigen", (newVal) {
                  data.show_favorites = newVal;
                  onSettingsChange(data);
                }, value: data.show_favorites),
                SettingsCheckbox("Watchlist öffentlich anzeigen", (newVal) {
                  data.show_watchlist = newVal;
                  onSettingsChange(data);
                }, value: data.show_watchlist),
                SettingsCheckbox("Freunde öffentlich anzeigen", (newVal) {
                  data.show_friends = newVal;
                  onSettingsChange(data);
                }, value: data.show_friends),
                SettingsCheckbox("Anime Liste öffentlich anzeigen", (newVal) {
                  data.show_list = newVal;
                  onSettingsChange(data);
                }, value: data.show_list),
              ],
            ),
            Theme(
                data: Theme.of(ctx)
                    .copyWith(canvasColor: Theme.of(ctx).backgroundColor),
                child: DropdownButton(
                    value: data.preferred_hoster_id,
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.caption.color,
                        fontSize: 15),
                    hint: Text(
                      "Bevorzogter Hoster",
                      style: TextStyle(
                          color: Theme.of(ctx).textTheme.caption.color),
                    ),
                    items: CacheManager.hosters
                        .map((hoster) => DropdownMenuItem<int>(
                              child: Text(hoster.name),
                              value: hoster.id,
                              onTap: () {
                                data.preferred_hoster_id = hoster.id;
                                onSettingsChange(data);
                              },
                            ))
                        .toList(),
                    onChanged: (value) {})),
            Theme(
                data: Theme.of(ctx)
                    .copyWith(canvasColor: Theme.of(ctx).backgroundColor),
                child: DropdownButton(
                    value: data.preferred_lang,
                    style: TextStyle(
                        color: Theme.of(ctx).textTheme.caption.color,
                        fontSize: 15),
                    hint: Text(
                      "Bevorzogte Sprache",
                      style: TextStyle(
                          color: Theme.of(ctx).textTheme.caption.color),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        child: Text("Sub"),
                        value: "SUB",
                        onTap: () {
                          data.preferred_lang = "SUB";
                          onSettingsChange(data);
                        },
                      ),
                      DropdownMenuItem<String>(
                        child: Text("Dub"),
                        value: "DUB",
                        onTap: () {
                          data.preferred_lang = "DUB";
                          onSettingsChange(data);
                        },
                      )
                    ],
                    onChanged: (value) {})),
          ],
        )
      ],
    );
  }

  Widget buildButtons(String buttonText, Function function, BuildContext ctx) {
    return OutlineButton(
        textColor: Theme.of(ctx).textTheme.caption.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        borderSide: BorderSide(color: Theme.of(ctx).textTheme.caption.color),
        child: Padding(
          child: ThemeText(buttonText),
          padding: EdgeInsets.only(bottom: 10, top: 10),
        ),
        onPressed: function);
  }

  void resetTextController() {
    usernameController.clear();
    passwortController.clear();
  }

  void showChangeDialog(BuildContext ctx, String title, Widget content,
      String okButtonText, Function okFunction) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ThemeText(title),
            backgroundColor: Theme.of(ctx).backgroundColor,
            contentTextStyle:
                TextStyle(color: Theme.of(ctx).textTheme.caption.color),
            content: content,
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Abbrechen",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              FlatButton(
                color: Colors.green,
                child: Text(
                  okButtonText,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: okFunction,
              )
            ],
          );
        });
  }

  void showErrorDialog(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new ThemeText("Error"),
          content: new ThemeText(
            message,
            softWrap: true,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new ThemeText("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
