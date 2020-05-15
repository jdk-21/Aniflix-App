import 'package:flutter/material.dart';

class ReportDialog extends StatelessWidget {
  Function(String) onSend;
  var controller = TextEditingController();

  ReportDialog(this.onSend);

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
      backgroundColor: Theme.of(ctx).backgroundColor,
      contentTextStyle: TextStyle(color: Theme.of(ctx).textTheme.title.color),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Text("Report schreiben"),
        TextField(
          style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
          keyboardType: TextInputType.multiline,
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Report'),
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
            "Absenden",
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
