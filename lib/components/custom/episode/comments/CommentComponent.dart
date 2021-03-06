import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/custom/images/ProfileImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentComponent extends StatelessWidget {
  User user;
  Function(String) callback;

  CommentComponent(this.user, this.callback);

  @override
  Widget build(BuildContext ctx) {
    var controller = TextEditingController();

    var textField = TextField(
      style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
      keyboardType: TextInputType.multiline,
      controller: controller,
      maxLines: null,
      maxLength: 1000,
      decoration:
          InputDecoration(fillColor: Colors.white,border: InputBorder.none, hintText: 'Kommentar'),
    );

    return Container(
      child: Row(
        children: <Widget>[
          ProfileImage(user.avatar,(){}),
          Expanded(child: textField),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(ctx).primaryIconTheme.color,
            onPressed: (){callback(controller.text);
            controller.text = "";}
          ),
        ],
      ),
    );
  }
}
