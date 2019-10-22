import 'package:flutter/material.dart';
import '../custom/text/highlighted_text_box.dart';

class SliderElement extends Container {
  Function onTap;
  String name;
  String description;
  String image;

  SliderElement({this.name, this.description, this.image, this.onTap})
      : super(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.fill)),
            child: Container(
              margin: EdgeInsets.all(25),
              child: Stack(
                children: [
                  (name != "")
                      ? Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: HighlightedTextBox(name))
                      : Align(alignment: AlignmentDirectional.bottomStart),
                  (description != "")
                      ? Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: HighlightedTextBox(description))
                      : Align(alignment: AlignmentDirectional.topEnd),
                ],
              ),
            ));
}
