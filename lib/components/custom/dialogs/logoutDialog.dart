import 'package:flutter/material.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class LogoutDialog extends StatelessWidget {
LogoutDialog();

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
      backgroundColor: Theme.of(ctx).backgroundColor,
      contentTextStyle: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
      content: ThemeText("Wirklich ausloggen?"),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          child: Text("Abbrechen", style: TextStyle(color: Colors.white),),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
        FlatButton(
          color: Colors.green,
          child: Text("Ausloggen", style: TextStyle(color: Colors.white),),
          onPressed: () async {
            SharedPreferences prefs =
            await SharedPreferences.getInstance();
            await prefs.remove("access_token");
            await prefs.remove("token_type");
            APIManager.login = null;
            AppState.updateLoggedIn(false);
            Navigator.of(ctx).pop();
            Navigator.of(ctx).pushNamed("login");
          },
        )
      ],
    );
  }
}
