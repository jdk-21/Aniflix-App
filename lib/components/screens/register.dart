import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget implements Screen {
  Register();

  @override
  getScreenName() {
    return "register_screen";
  }

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
                            color: Theme.of(ctx).textTheme.caption.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 25))
                  ])),
              SizedBox(height: 30),
              TextField(
                controller: usernameController,
                style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
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
                style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
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
                style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
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
                style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
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
                    textColor: Theme.of(ctx).textTheme.caption.color,
                    borderSide: BorderSide(
                        color: Theme.of(ctx).textTheme.caption.color),
                    child: Text("Registrieren"),
                    onPressed: () async {
                      if (passwortController.text ==
                          passwortWiederholenController.text) {
                        var token = null; //TODO
                        var response = await APIManager.registerRequest(
                            emailController.text,
                            passwortController.text,
                            token,
                            usernameController.text);
                        if (response.hasError()) {
                          //TODO
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              ctx, 'login', (Route<dynamic> route) => false);
                        }
                      } else {
                        //TODO
                      }
                      resetTextController();
                    },
                  )),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  textColor: Theme.of(ctx).textTheme.caption.color,
                  child: Text("Schon einen Account?"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        ctx, 'login', (Route<dynamic> route) => false);
                    resetTextController();
                  },
                ),
              )
            ])
          ])),
    );
  }

  void resetTextController() {
    usernameController.clear();
    emailController.clear();
    passwortController.clear();
    passwortWiederholenController.clear();
  }
}
