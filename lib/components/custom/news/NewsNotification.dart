import 'package:aniflix_app/components/custom/news/aniflix_notification.dart';
import 'package:aniflix_app/components/custom/text/theme_text.dart';

class NewsNotification extends AniflixNotification {
  String _message;

  NewsNotification(this._message)
      : super(ThemeText(
          _message,
          softWrap: true,
        ));
}
