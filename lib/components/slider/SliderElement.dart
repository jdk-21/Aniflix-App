import 'package:flutter/material.dart';

class SliderElement extends Container {
  Function onTap;
  String name;
  String description;
  String image;

  SliderElement({this.name, this.description, this.image, this.onTap})
      : super(
    child: Stack(
      children: [
        Image.network(image),
        Padding(padding: EdgeInsets.only(left: 10, top: 130), child: Text(name,style: TextStyle(color: Colors.white, backgroundColor: Colors.black))),
        Padding(padding: EdgeInsets.only(left: 250, top: 10), child: Text(description,style: TextStyle(color: Colors.white, backgroundColor: Colors.black)))
      ],
    ),
  );
}