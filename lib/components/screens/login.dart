import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  MainWidgetState state;

  Login(this.state);

  final emailController = TextEditingController();
  final passwortController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    //bool angemeldetBleiben = false;
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
                    Text("User Login",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            color: Theme.of(ctx).textTheme.title.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 25))
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
              /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Theme(
                      child: Checkbox(
                        onChanged: (newValue) {
                          angemeldetBleiben = newValue;
                        },
                        value: angemeldetBleiben,
                      ),
                      data: Theme.of(ctx).copyWith(
                          unselectedWidgetColor:
                              Theme.of(ctx).textTheme.title.color),
                    ),
                    Text(
                      "Angemeldet bleiben",
                      style:
                          TextStyle(color: Theme.of(ctx).textTheme.title.color),
                    )
                  ]),
              SizedBox(height: 15),*/
              Align(
                  alignment: Alignment.center,
                  child: OutlineButton(
                    textColor: Theme.of(ctx).textTheme.title.color,
                    borderSide:
                        BorderSide(color: Theme.of(ctx).textTheme.title.color),
                    child: Text("Login"),
                    onPressed: () async {
                      var response = await APIManager.loginRequest(emailController.value.text, passwortController.value.text);
                      if(response.hasError()){
                        showErrorDialog(ctx,response.error);
                      }else{
                        state.changePage(Home(),0);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("access_token", response.access_token);
                        prefs.setString("token_type", response.token_type);
                        resetTextController();
                      }
                    },
                  )),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  textColor: Theme.of(ctx).textTheme.title.color,
                  child: Text("Noch keinen Account?"),
                  onPressed: () {
                    _launchURL();
                    //state.changePage(5);
                    //ScreenManager.getInstance(state).setCurrentTab(5);
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
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
