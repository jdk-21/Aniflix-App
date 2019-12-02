import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/User.dart';
import './AnswerCommentComponent.dart';

class AnswerBar extends StatefulWidget {
  User _user;
  Function(AnswerBarState) _created;
  Function(String) _callback;

  AnswerBar(this._user, this._created,this._callback);

  @override
  AnswerBarState createState() => AnswerBarState(this._user, this._created,this._callback);
}

class AnswerBarState extends State<AnswerBar> {
  User _user;
  bool _needAnswer;
  Function(AnswerBarState) _created;
  Function(String) _callback;

  AnswerBarState(this._user, this._created,this._callback);

  @override
  void initState() {
    _needAnswer = false;
    this._created(this);
    super.initState();
  }

  toggleState() {
    setState(() {
      this._needAnswer = !_needAnswer;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return _needAnswer ? AnswerCommentComponent(this._user,_callback) : SizedBox();
  }
}
