import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget{

  String avatar;
  Function onTap;

  ProfileImage(this.avatar, this.onTap);

  @override
  build(BuildContext ctx){
    return (avatar == null)
        ? IconButton(
      key: Key("Settings"),
      icon: Icon(
        Icons.person,
        color: Theme.of(ctx).primaryIconTheme.color,
      ),
      onPressed: () {
        Navigator.pushNamed(ctx, "settings");
      },
    )
        : IconButton(
      key: Key("Settings"),
      icon: new Container(
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(
                  "https://www2.aniflix.tv/storage/" + avatar,
                ),
              ))),
      onPressed: onTap
    );
  }
}