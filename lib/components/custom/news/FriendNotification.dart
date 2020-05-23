import 'package:flutter/material.dart';
import 'package:aniflix_app/cache/cacheManager.dart';
import 'package:aniflix_app/components/custom/news/PersonalNotification.dart';

class FriendNotification extends PersonalNotification {
  FriendNotification(
      int _id, String _message, Function(int) onDelete, BuildContext ctx)
      : super(_id, _message, () {
          Navigator.pushNamed(ctx, "profil",
              arguments: CacheManager.userData.id);
        }, onDelete, ctx);
}
