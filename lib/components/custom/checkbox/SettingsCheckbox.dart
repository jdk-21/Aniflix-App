import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsCheckbox extends StatelessWidget {
  String title;
  bool value;
  Function(bool) onChanged;

  SettingsCheckbox(this.title, this.onChanged, {this.value = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 3.0, color: Theme.of(context).iconTheme.color),
          ),
          width: 20,
          height: 20,
          child: Checkbox(
              value: this.value,
              activeColor: Theme.of(context).iconTheme.color,
              onChanged: onChanged)),
      SizedBox(
        width: 10,
      ),
      ThemeText(title)
    ]);
  }
}
