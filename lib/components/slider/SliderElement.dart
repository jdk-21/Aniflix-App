import 'package:flutter/material.dart';
import '../custom/text/highlighted_text_box.dart';

class SliderElement extends Container {
  Function onTap;
  String name;
  String description;
  String image;

  SliderElement({this.name, this.description, this.image, this.onTap})
      : super(
            margin: EdgeInsets.only(left: 3,right: 3),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.fill)),
            child: Container(
              margin: EdgeInsets.all(10),
              child: Stack(
                children: [
                  (name != "" && name != null)
                      ? Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: HighlightedTextBox(name))
                      : Align(alignment: AlignmentDirectional.bottomStart),
                  (description != "" && description != null)
                      ? Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: HighlightedTextBox(description))
                      : Align(alignment: AlignmentDirectional.topEnd),
                ],
              ),
            ));
}
