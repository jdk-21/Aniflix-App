import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class ProfileSettings extends StatelessWidget implements Screen {
  ProfileSettings(){
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
                ctx,
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
                        var a = (CacheManager.userlistdata.users.where((element) => (element.name.toLowerCase().compareTo(usernameController.value.text) == 0)));
                        if(a.length > 0) {
                          showErrorDialog(ctx, "Dieser Username existiert bereits. Bitte wähle einen anderen.");
                        } else {
                          APIManager.updateName(usernameController.value.text);
                          CacheManager.userData.name = usernameController.value.text;
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
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildButtons(String buttonText, Function function, BuildContext ctx) {
    return OutlineButton(
        textColor: Theme.of(ctx).textTheme.caption.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        borderSide: BorderSide(color: Theme.of(ctx).textTheme.caption.color),
        child: Padding(
          child: ThemeText(buttonText, ctx),
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
            title: ThemeText(title, ctx),
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
          title: new ThemeText("Error", context),
          content: new ThemeText(
            message,
            context,
            softWrap: true,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new ThemeText("Close", context),
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
