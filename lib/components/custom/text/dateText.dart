import 'package:aniflix_app/components/custom/text/theme_text.dart';
import 'package:flutter/widgets.dart';

class DateText extends StatelessWidget{
  String unformattedDate;
  bool showTime;

  DateText(this.unformattedDate, {this.showTime = false});

  @override
  Widget build(BuildContext context) {
    String formattedDate;
    var date = DateTime.parse(unformattedDate);
    formattedDate = date.day.toString() + "." + date.month.toString() + "." + date.year.toString();
    if(showTime){
      formattedDate += " " + date.hour.toString() + ":" + date.minute.toString() + ":" + date.second.toString();
    }
    return ThemeText(formattedDate, context, fontSize: 15,);
  }
}