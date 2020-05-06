import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class CloseAppDialog extends StatelessWidget {
  Function(bool) _onPress;
  CloseAppDialog(this._onPress);

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
      backgroundColor: Theme.of(ctx).backgroundColor,
      contentTextStyle: TextStyle(color: Theme.of(ctx).textTheme.title.color),
      content: ThemeText("App beenden?",ctx),
      actions: <Widget>[
        FlatButton(
          color: Colors.green,
          child: Text("Abbrechen", style: TextStyle(color: Colors.white),),
          onPressed: () {
            _onPress(false);
            Navigator.of(ctx).pop();
          },
        ),
        FlatButton(
          color: Colors.red,
          child: Text("Beenden", style: TextStyle(color: Colors.white),),
          onPressed: () async {
            _onPress(true);
            Navigator.of(ctx).pop();
          },
        )
      ],
    );
  }
}
