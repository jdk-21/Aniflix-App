import 'package:aniflix_app/main.dart';
import 'package:aniflix_app/components/navigationbars/mainbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  MainWidgetState state;

  Login(this.state);

  @override
  Widget build(BuildContext ctx) {
    bool angemeldetBleiben = false;
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
                decoration: InputDecoration(
                    hintText: "E-Mail",
                    hintStyle:
                        TextStyle(color: Theme.of(ctx).hintColor, fontSize: 15),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(ctx).hintColor))),
              ),
              SizedBox(height: 30),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Passwort",
                    hintStyle:
                        TextStyle(color: Theme.of(ctx).hintColor, fontSize: 15),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(ctx).hintColor))),
              ),
              SizedBox(height: 30),
              Row(
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
              SizedBox(height: 15),
              Align(
                  alignment: Alignment.center,
                  child: OutlineButton(
                    textColor: Theme.of(ctx).textTheme.title.color,
                    borderSide:
                        BorderSide(color: Theme.of(ctx).textTheme.title.color),
                    child: Text("Login"),
                    onPressed: () {
                      state.changePage(0);
                      ScreenManager.getInstance(state).setCurrentTab(0);
                    },
                  )),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  textColor: Theme.of(ctx).textTheme.title.color,
                  child: Text("Noch keinen Account?"),
                  onPressed: () {
                    state.changePage(5);
                    ScreenManager.getInstance(state).setCurrentTab(5);
                  },
                ),
              )
            ])
          ])),
    );
  }
}
