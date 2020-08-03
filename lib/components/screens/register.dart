import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/api/recaptcha.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget implements Screen {
  @override
  getScreenName() {
    return "register_screen";
  }

  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwortController = TextEditingController();
  final passwortWiederholenController = TextEditingController();
  RecaptchaV2Controller recaptchaV2Controller;
  String _captchaToken;

  @override
  void initState() {
    recaptchaV2Controller = RecaptchaV2Controller();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return new Container(
      color: Theme.of(ctx).backgroundColor,
      child: (_captchaToken == null)
          ? Stack(children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("SHOW ReCAPTCHA"),
                      onPressed: () {
                        recaptchaV2Controller.show();
                      },
                    ),
                    FlatButton(
                      textColor: Theme.of(ctx).textTheme.caption.color,
                      child: Text("Schon einen Account?"),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            ctx, 'login', (Route<dynamic> route) => false);
                        resetTextController();
                      },
                    )
                  ],
                ),
              ),
              ListView(children: [
                SizedBox(
                  height: 100,
                ),
                Expanded(
                    child: Center(
                        child: RecaptchaV2(
                  apiKey: "6LccnrgZAAAAAKvgkI1pDqb3IRqA52iKUt49Csa2",
                  controller: recaptchaV2Controller,
                  onVerifiedError: (err) {
                    print("onVerifiedError");
                    print(err);
                    recaptchaV2Controller.hide();
                    recaptchaV2Controller.show();
                  },
                  onVerifiedSuccessfully: (token) {
                    setState(() {
                      print("token:");
                      print(token);
                      recaptchaV2Controller.hide();
                      recaptchaV2Controller = RecaptchaV2Controller();
                      _captchaToken = token;
                    });
                  },
                )))
              ])
            ])
          : Padding(
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
                    style:
                        TextStyle(color: Theme.of(ctx).textTheme.caption.color),
                    decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(
                            color: Theme.of(ctx).hintColor, fontSize: 15),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(ctx).hintColor))),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: emailController,
                    style:
                        TextStyle(color: Theme.of(ctx).textTheme.caption.color),
                    decoration: InputDecoration(
                        hintText: "E-Mail",
                        hintStyle: TextStyle(
                            color: Theme.of(ctx).hintColor, fontSize: 15),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(ctx).hintColor))),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: passwortController,
                    style:
                        TextStyle(color: Theme.of(ctx).textTheme.caption.color),
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Passwort",
                        hintStyle: TextStyle(
                            color: Theme.of(ctx).hintColor, fontSize: 15),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(ctx).hintColor))),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: passwortWiederholenController,
                    style:
                        TextStyle(color: Theme.of(ctx).textTheme.caption.color),
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Passwort wiederholen",
                        hintStyle: TextStyle(
                            color: Theme.of(ctx).hintColor, fontSize: 15),
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
                            var response = await APIManager.registerRequest(
                                emailController.text,
                                passwortController.text,
                                _captchaToken,
                                usernameController.text);
                            if (response.hasError()) {
                              if (response.error == "Email already in use") {
                                showErrorDialog(
                                    ctx, "Die Email wird bereits verwendet!");
                              } else if (response.error ==
                                  "Username already in use") {
                                showErrorDialog(ctx,
                                    "Der Username wird bereits verwendet!");
                              } else {
                                showErrorDialog(
                                    ctx, "Captcha war nicht erfolgerich!");
                                setState(() {
                                  _captchaToken = null;
                                });
                              }
                              print("Response Error:");
                              print(response.error);
                            } else {
                              showErrorDialog(
                                  ctx, "Registrierung war erfolgreich!",
                                  error: false);
                              Navigator.pushNamedAndRemoveUntil(ctx, 'login',
                                  (Route<dynamic> route) => false);
                            }
                          } else {
                            showErrorDialog(
                                ctx, "Die Passwörter stimmen nicht überein!");
                            print("Password dont match");
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

  void showErrorDialog(BuildContext ctx, String message, {bool error = true}) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new ThemeText(error ? "Error" : "Success"),
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

  void resetTextController() {
    usernameController.clear();
    emailController.clear();
    passwortController.clear();
    passwortWiederholenController.clear();
  }
}
