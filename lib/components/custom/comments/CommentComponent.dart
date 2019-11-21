import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:aniflix_app/components/custom/comments/commentContainer.dart';
import 'package:aniflix_app/components/screens/episode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentComponent extends StatelessWidget {
  User user;
  EpisodeScreenState state;

  CommentComponent(this.user, this.state);

  @override
  Widget build(BuildContext ctx) {
    var controller = TextEditingController();

    var textField = TextField(
      style: TextStyle(color: Theme.of(ctx).textTheme.title.color),
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
          (user.avatar == null)
              ? IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(ctx).primaryIconTheme.color,
                  ),
                )
              : IconButton(
                  icon: new Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              "https://www2.aniflix.tv/storage/" + user.avatar,
                            ),
                          ))),
                  onPressed: () => {},
                ),
          Expanded(child: textField),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(ctx).primaryIconTheme.color,
            onPressed: () {
              Comment newComment = new Comment(
                  null,
                  controller.text,
                  user.id,
                  "App\\Comment",
                  null,
                  DateTime.now().toIso8601String(),
                  null,
                  null,
                  null,
                  user, [], []);

              state.addComment(newComment);
              /*CommentContainer comment = new CommentContainer(newComment, user);*/

              controller.text = "";
            },
          ),
        ],
      ),
    );
  }
}
