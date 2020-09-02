import 'package:aniflix_app/api/requests/user/LoginRequests.dart';
import 'package:aniflix_app/api/requests/user/ProfileRequests.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Login extends StatelessWidget implements Screen {
  FirebaseAnalytics analytics;

  Login() {
    this.analytics = AppState.analytics;
  }

  @override
  getScreenName() {
    return "login_screen";
  }

  final emailController = TextEditingController();
  final passwortController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return new Container(
      color: Theme.of(ctx).backgroundColor,
      child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: ListView(children: [
            Column(children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Column(children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(ctx).primaryIconTheme.color,
                      size: 50,
                    ),
                    ThemeText("User Login",
                        fontWeight: FontWeight.bold, fontSize: 25)
                  ])),
              SizedBox(height: 30),
              TextField(
                  style:
                      TextStyle(color: Theme.of(ctx).textTheme.caption.color),
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "E-Mail",
                      hintStyle: TextStyle(
                          color: Theme.of(ctx).hintColor, fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(ctx).hintColor)))),
              SizedBox(height: 30),
              TextField(
                  style:
                      TextStyle(color: Theme.of(ctx).textTheme.caption.color),
                  controller: passwortController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Passwort",
                      hintStyle: TextStyle(
                          color: Theme.of(ctx).hintColor, fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(ctx).hintColor)))),
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.center,
                  child: OutlineButton(
                    textColor: Theme.of(ctx).textTheme.caption.color,
                    borderSide: BorderSide(
                        color: Theme.of(ctx).textTheme.caption.color),
                    child: ThemeText("Login"),
                    onPressed: () async {
                      var response = await LoginRequests.loginRequest(
                          emailController.value.text,
                          passwortController.value.text);
                      if (response.hasError()) {
                        CacheManager.session = null;
                        showErrorDialog(
                            ctx,
                            (response.error == "Unauthorized")
                                ? "Email oder Passwort falsch!"
                                : response.error);
                      } else {
                        CacheManager.session = response;
                        AppState.updateLoggedIn(true);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                            "access_token", response.access_token);
                        await prefs.setString(
                            "token_type", response.token_type);
                        resetTextController();
                        analytics.logLogin();

                        Navigator.pushNamedAndRemoveUntil(
                            ctx, '/', (Route<dynamic> route) => false);
                        AppState.setIndex(0);
                        ProfileRequests.getUser()
                            .then((value) => CacheManager.userData = value);
                      }
                    },
                  )),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  textColor: Theme.of(ctx).textTheme.caption.color,
                  child: ThemeText("Noch keinen Account?"),
                  onPressed: () {
                    //_launchURL();
                    Navigator.pushNamedAndRemoveUntil(
                        ctx, 'register', (Route<dynamic> route) => false);
                    resetTextController();
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  textColor: Theme.of(ctx).textTheme.caption.color,
                  child: ThemeText("Ohne Account weiter"),
                  onPressed: () {
                    //_launchURL();
                    AppState.updateOfflineMode(true);
                    Navigator.pushNamedAndRemoveUntil(
                        ctx, '/', (Route<dynamic> route) => false);
                    resetTextController();
                    AppState.setIndex(0);
                  },
                ),
              )
            ])
          ])),
    );
  }

  void resetTextController() {
    emailController.clear();
    passwortController.clear();
  }

  void showErrorDialog(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new ThemeText("Error"),
          content: new ThemeText(message),
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
