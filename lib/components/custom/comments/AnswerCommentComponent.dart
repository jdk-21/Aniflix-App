import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/components/custom/comments/commentContainer.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:aniflix_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerCommentComponent extends StatefulWidget {

  User user;
  CommentContainerState state;

  AnswerCommentComponent(this.user, this.state);

  @override
  AnswerCommentComponentState createState() =>
      AnswerCommentComponentState(user, state);
}

class AnswerCommentComponentState extends State<AnswerCommentComponent> {

  User user;
  CommentContainerState state;

  AnswerCommentComponentState(this.user, this.state);

  @override
  Widget build(BuildContext ctx){

    var controller = TextEditingController();

    var textField = TextField(
      style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
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
          (user.avatar == null)
              ? IconButton(
            iconSize: 1,
            icon: Icon(
              Icons.person,
              color: Theme.of(ctx).primaryIconTheme.color,
            ),
            onPressed: (){},
          )
              :Transform.scale(
            scale: 0.6,
            child: IconButton(
              icon: new Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: NetworkImage(
                          "https://www2.aniflix.tv/storage/" +
                              user.avatar,
                        ),
                      ))),
              onPressed: () => {},
            ),
          ),


          Expanded(child: textField,),
          IconButton(
            icon: Icon(Icons.send, size: 15,),
            color: Theme.of(ctx).primaryIconTheme.color,
            onPressed: () {
              controller.text = "";
              state.changeNeedAnswer();
            },
          ),
        ],
      ),
    );
  }
}