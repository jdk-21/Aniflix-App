import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class Profil extends StatelessWidget implements Screen{

  @override
  getScreenName() {
    return "profile_screen";
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(key: Key("profile_screen"),
      child: Center(child: ThemeText("Profil",ctx, fontSize: 24.0),),color: Theme.of(ctx).backgroundColor,);
  }
}