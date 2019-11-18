import 'package:aniflix_app/api/objects/User.dart';
import 'package:aniflix_app/api/objects/anime/Vote.dart';
import 'package:aniflix_app/api/objects/episode/Comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatefulWidget {
  Comment comment;

  CommentContainer(Comment comment) {
    this.comment = comment;
  }

  @override
  CommentContainerState createState() => CommentContainerState(this.comment);
}

class CommentContainerState extends State<CommentContainer> {
  String text;
  User user;
  List<SubComment> subComments = [];
  List<Vote> votes = [];
  String createdAt;
  int voted;
  String _actualVote;
  List<String> possibleVotes = [null, "+", "-"];
  int _numberOfUpVotes;
  int _numberOfDownVotes;

  CommentContainerState(Comment comment) {
    this.text = comment.text;
    this.user = comment.user;
    this.subComments = comment.comments;
    this.votes = comment.votes;
    this.voted = comment.voted;
    this.createdAt = comment.created_at;
  }

  makeUpVote() {
    setState(() {
      if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
        _actualVote = possibleVotes.elementAt(1);
        _numberOfUpVotes = _numberOfUpVotes + 1;
      } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
        _actualVote = possibleVotes.elementAt(0);
        _numberOfUpVotes = _numberOfUpVotes - 1;
      } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
        _actualVote = possibleVotes.elementAt(1);
        _numberOfDownVotes = _numberOfDownVotes - 1;
        _numberOfUpVotes = _numberOfUpVotes + 1;
      }
    });
  }

  makeDownVote() {
    setState(() {
      if (_actualVote == possibleVotes.elementAt(0) /*null*/) {
        _actualVote = possibleVotes.elementAt(2);
        _numberOfDownVotes = _numberOfDownVotes + 1;
      } else if (_actualVote == possibleVotes.elementAt(1) /*+*/) {
        _actualVote = possibleVotes.elementAt(2);
        _numberOfUpVotes = _numberOfUpVotes - 1;
        _numberOfDownVotes = _numberOfDownVotes + 1;
      } else if (_actualVote == possibleVotes.elementAt(2) /*-*/) {
        _actualVote = possibleVotes.elementAt(0);
        _numberOfDownVotes = _numberOfDownVotes - 1;
      }
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      color: Theme.of(ctx).backgroundColor,
      child: Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (user.avatar == null)
                ? Icon(Icons.person)
                : Image.network(
                    "https://www2.aniflix.tv/storage/" + user.avatar)
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
           Row(
             children: [
               Text(
                 user.name + " ",
                 style: TextStyle(color: Colors.white, fontSize: 12.0),
               ),
               (this.createdAt != null)
               ?Text(
                 this.createdAt,
                 style: TextStyle(color: Colors.white, fontSize: 9.0)
               )
                   :Text(
                 "",
                   style: TextStyle(color: Colors.white, fontSize: 10.0)
               )

             ],
           ),
            Row(
              children: [
                Text(
                  this.text,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                )
              ],
            )
          ],
        )
      ]),
    );
  }
}
