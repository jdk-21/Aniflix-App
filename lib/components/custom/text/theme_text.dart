import 'package:flutter/material.dart';

class ThemeText extends Text {
  ThemeText(String text, BuildContext ctx,
      {double fontSize = 20,
      FontWeight fontWeight = FontWeight.normal,
      bool softWrap = false,
      TextAlign textAlign,
      int maxLines})
      : super(text,
            style: TextStyle(
                color: Theme.of(ctx).textTheme.title.color,
                fontSize: fontSize,
                fontWeight: fontWeight),
            softWrap: softWrap,
            textAlign: textAlign,
            maxLines: maxLines
  );
}