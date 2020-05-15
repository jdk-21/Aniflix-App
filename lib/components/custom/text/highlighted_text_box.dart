import 'package:flutter/material.dart';

class HighlightedTextBox extends Container {

  Color color;

  HighlightedTextBox(String text, {this.color = const Color.fromRGBO(15, 15, 15, 1)})
      : super(
          padding: EdgeInsets.all(5),
          decoration: new BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.all(const Radius.circular(40.0)),),
          child: Text(text, style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis),
        );
}
