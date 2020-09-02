import 'package:aniflix_app/api/requests/BasicRequests.dart';
import 'package:aniflix_app/api/requests/exceptions/RequiresLoginException.dart';
import 'package:aniflix_app/cache/cacheManager.dart';

enum AniflixRequestType { Requires_Login, Prefers_Login, No_Login }

class AniflixRequest extends BasicRequests {
  AniflixRequestType type;

  AniflixRequest(String query,
      {this.type = AniflixRequestType.Requires_Login,
      Map<String, String> headers})
      : super('https://www2.aniflix.tv/api/' + query) {
    if(headers == null) headers = {};
    switch (type) {
      case AniflixRequestType.Requires_Login:
        headers["Authorization"] = _checkLogin(headers, true);
        break;
      case AniflixRequestType.Prefers_Login:
        headers["Authorization"] = _checkLogin(headers, false);
        break;
      case AniflixRequestType.No_Login:
        break;
    }
    this.headers = headers;
  }

  static String _checkLogin(Map<String, String> headers, bool required) {
    var login = CacheManager.session;
    if (login == null) if (!required)
      return null;
    else
      throw RequiresLoginException();
    if (login.hasError()) if (!required)
      return null;
    else
      throw RequiresLoginException.hasError(login.error);
    if (login.token_type == null) if (!required)
      return null;
    else
      throw RequiresLoginException.noTokenType();
    if (login.access_token == null) if (!required)
      return null;
    else
      throw RequiresLoginException.noToken();
    return login.token_type + " " + login.access_token;
  }
}
