import '../../screens/login.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/api/APIManager.dart';
import 'package:aniflix_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class LogoutDialog extends StatelessWidget {
MainWidgetState state;
LogoutDialog(this.state);

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
      backgroundColor: Theme.of(ctx).backgroundColor,
      contentTextStyle: TextStyle(color: Theme.of(ctx).textTheme.title.color),
      content: ThemeText("Wirklich ausloggen?",ctx),
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
            Navigator.of(ctx).pop();
            SharedPreferences prefs =
            await SharedPreferences.getInstance();
            prefs.remove("access_token");
            prefs.remove("token_type");
            APIManager.login = null;
            state.changePage(Login(state), 0);
          },
        )
      ],
    );
  }
}
