import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HighlightedTextBox extends StatelessWidget {

  Color color;
  String text;
  double size;

  HighlightedTextBox(this.text, {this.color = const Color.fromRGBO(15, 15, 15, 1), this.size = 14.0});

  @override
  Widget build(BuildContext context){
    return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: color,),
          child: Text(text, style: TextStyle(color: Colors.white,fontSize: size), overflow: TextOverflow.ellipsis,),
    );
  }
}
