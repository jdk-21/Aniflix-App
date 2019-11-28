import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  MainWidgetState state;

  Register(this.state);

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwortController = TextEditingController();
  final passwortWiederholenController = TextEditingController();

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
                    Text("Registrierung",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            color: Theme.of(ctx).textTheme.title.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 25))
                  ])),
              SizedBox(height: 30),
              TextField(
                controller: usernameController,
                style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
                decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle:
                        TextStyle(color: Theme.of(ctx).hintColor, fontSize: 15),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(ctx).hintColor))),
              ),
              SizedBox(height: 30),
              TextField(
                controller: emailController,
                style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
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
                controller: passwortController,
                style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
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
              TextField(
                controller: passwortWiederholenController,
                style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Passwort wiederholen",
                    hintStyle:
                        TextStyle(color: Theme.of(ctx).hintColor, fontSize: 15),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(ctx).hintColor))),
              ),
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.center,
                  child: OutlineButton(
                    textColor: Theme.of(ctx).textTheme.title.color,
                    borderSide:
                        BorderSide(color: Theme.of(ctx).textTheme.title.color),
                    child: Text("Registrieren"),
                    onPressed: () {
                      resetTextController();
                    },
                  )),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  textColor: Theme.of(ctx).textTheme.title.color,
                  child: Text("Schon einen Account?"),
                  onPressed: () {
                    resetTextController();
                  },
                ),
              )
            ])
          ])),
    );
  }

  void resetTextController(){
    usernameController.clear();
    emailController.clear();
    passwortController.clear();
    passwortWiederholenController.clear();
  }
}
