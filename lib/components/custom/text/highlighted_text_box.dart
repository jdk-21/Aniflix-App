import 'package:flutter/material.dart';

class HighlightedTextBox extends Container {
  HighlightedTextBox(String text)
      : super(
          padding: EdgeInsets.all(5),
          decoration: new BoxDecoration(
              color: Colors.black,
              borderRadius: new BorderRadius.all(const Radius.circular(40.0))),
          child: Text(text, style: TextStyle(color: Colors.white)),
        );
}
