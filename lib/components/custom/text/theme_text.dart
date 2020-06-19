import 'package:flutter/material.dart';

class ThemeText extends StatelessWidget {
  String text;
  double fontSize = 20;
  FontWeight fontWeight = FontWeight.normal;
  bool softWrap = false;
  TextAlign textAlign;
  int maxLines;
  TextOverflow overflow;

  ThemeText(this.text,
      {this.fontSize,
      this.fontWeight,
      this.softWrap,
      this.textAlign,
      this.maxLines,
      this.overflow});

  @override
  Widget build(BuildContext ctx) {
    return Text(text,
        style: TextStyle(
            color: Theme.of(ctx).textTheme.caption.color,
            fontSize: fontSize,
            fontWeight: fontWeight),
        softWrap: softWrap,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow);
  }
}
