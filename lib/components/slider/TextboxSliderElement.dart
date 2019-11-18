import 'package:flutter/material.dart';

class TextboxSliderElement extends Container {
  TextboxSliderElement(String text)
      : super(
    margin: EdgeInsets.only(right: 5),
    padding: EdgeInsets.all(5),
    decoration: new BoxDecoration(
        color: Color.fromRGBO(15, 15, 19, 1),
        borderRadius: new BorderRadius.all(const Radius.circular(40.0)),
        border: Border.all(color: Colors.grey, width: 1)),
    child: Center(child: Text(text, style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis),)
  );
}