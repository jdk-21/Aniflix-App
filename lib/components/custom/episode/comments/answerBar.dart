import 'package:flutter/material.dart';
import 'package:aniflix_app/api/objects/User.dart';
import './AnswerCommentComponent.dart';

class AnswerBar extends StatelessWidget {
  User _user;
  bool _needAnswer;
  Function(String) _callback;

  AnswerBar(this._user,this._needAnswer,this._callback);

  @override
  Widget build(BuildContext ctx) {
    return _needAnswer ? AnswerCommentComponent(this._user,_callback) : SizedBox();
  }
}
