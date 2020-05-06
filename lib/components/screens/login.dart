import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Login extends StatelessWidget implements Screen{
  FirebaseAnalytics analytics;

  Login(){
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
                        ctx,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)
                  ])),
              SizedBox(height: 30),
              TextField(
                  style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
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
                  style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
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
                    textColor: Theme.of(ctx).textTheme.title.color,
                    borderSide:
                        BorderSide(color: Theme.of(ctx).textTheme.title.color),
                    child: ThemeText("Login",ctx),
                    onPressed: () async {
                      var response = await APIManager.loginRequest(emailController.value.text, passwortController.value.text);
                      if(response.hasError()){
                        APIManager.login = null;
                        showErrorDialog(ctx,response.error);
                      }else{
                        AppState.updateLoggedIn(true);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("access_token", response.access_token);
                        prefs.setString("token_type", response.token_type);
                        resetTextController();
                        analytics.logLogin();
                      }
                    },
                  )),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  textColor: Theme.of(ctx).textTheme.title.color,
                  child: ThemeText("Noch keinen Account?",ctx),
                  onPressed: () {
                    _launchURL();
                    resetTextController();
                  },
                ),
              )
            ])
          ])),
    );
  }
  _launchURL() async {
    const url = 'https://www2.aniflix.tv/register';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void resetTextController() {
    emailController.clear();
    passwortController.clear();
  }
  void showErrorDialog(BuildContext ctx, String message){
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new ThemeText("Error",context),
          content: new ThemeText(message,context),
          actions: <Widget>[
            new FlatButton(
              child: new ThemeText("Close",context),
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
