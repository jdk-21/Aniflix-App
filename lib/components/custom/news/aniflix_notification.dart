import 'package:flutter/material.dart';

abstract class AniflixNotification extends StatelessWidget {
  Widget _body;

  AniflixNotification(this._body);

  @override
  Widget build(BuildContext ctx) {
    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme.of(ctx).hintColor,
                    style: BorderStyle.solid))),
        child: _body);
  }
}
