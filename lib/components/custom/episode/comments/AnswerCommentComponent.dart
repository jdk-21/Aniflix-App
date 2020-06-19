import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/custom/images/ProfileImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerCommentComponent extends StatefulWidget {

  User user;
  Function(String) _callback;

  AnswerCommentComponent(this.user, this._callback);

  @override
  AnswerCommentComponentState createState() =>
      AnswerCommentComponentState(user, this._callback);
}

class AnswerCommentComponentState extends State<AnswerCommentComponent> {

  User user;
  Function(String) _callback;

  AnswerCommentComponentState(this.user, this._callback);

  @override
  Widget build(BuildContext ctx){

    var controller = TextEditingController();

    var textField = TextField(
      style: TextStyle(color: Theme.of(ctx).textTheme.caption.color),
      keyboardType: TextInputType.multiline,
      controller: controller,
      maxLines: null,
      maxLength: 1000,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Antwort'),
    );

    return Container(
      padding: EdgeInsets.only(left: 55),
      child: Row(
        children: <Widget>[
          ProfileImage(user.avatar,(){}),
          Expanded(child: textField,),
          IconButton(
            icon: Icon(Icons.send, size: 15,),
            color: Theme.of(ctx).primaryIconTheme.color,
            onPressed: () {
              _callback(controller.text);
              controller.text = "";
            },
          ),
        ],
      ),
    );
  }
}