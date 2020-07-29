import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppErrorScreen extends StatelessWidget {
  String message;

  AppErrorScreen(this.message);

  @override
  Widget build(BuildContext ctx) {
    return Container(
        color: Theme.of(ctx).backgroundColor,
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 100,
              ),
              SizedBox(
                height: 50,
              ),
              Icon(
                Icons.warning,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: MediaQuery.of(ctx).size.width * 0.75,
                  child: ThemeText(
                    message,
                    fontSize: 25,
                  )),
              SizedBox(
                height: 50,
              ),Container(child:
              FlatButton(
                child: ThemeText("Neu Verbinden"),
                onPressed: () {
                  AppState.setLoading(true);
                  AppState.checkAppStatus();
                },
              ),decoration: BoxDecoration(border: Border.all(width: 1, color: Theme.of(ctx).textTheme.caption.color)),)
            ],
          ),
        ]));
  }
}
