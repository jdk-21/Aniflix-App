import 'package:flutter/material.dart';

class AboutMeDialog extends StatelessWidget {
  Function(String) onSend;
  var controller = TextEditingController();

  AboutMeDialog(this.onSend);

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
      backgroundColor: Theme.of(ctx).backgroundColor,
      contentTextStyle: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Text("About Me:"),
          TextField(
            style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
            keyboardType: TextInputType.multiline,
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'About Me:'),
          )],

      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          child: Text(
            "Abbrechen",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
        FlatButton(
          color: Colors.green,
          child: Text(
            "Abgeben",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            onSend(controller.text);
            controller.text = "";
            Navigator.of(ctx).pop();
          },
        )
      ],
    );
  }
}
