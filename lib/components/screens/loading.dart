import 'package:aniflix_app/components/screens/screen.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget implements Screen{

  LoadingScreen();

  @override
  getScreenName() {
    return "loading_screen";
  }
  @override
  Widget build(BuildContext ctx) {
    return Container(
      color: Theme.of(ctx).backgroundColor,
      child: Center(child: CircularProgressIndicator()),
    );
  }

}