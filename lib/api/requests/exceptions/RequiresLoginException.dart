import 'package:aniflix_app/api/requests/exceptions/AniflixException.dart';

class RequiresLoginException extends AniflixException {
  RequiresLoginException(
      {String message = "The required login was not provided!"})
      : super("RequiresLoginException", message);

  factory RequiresLoginException.hasError(String error) {
    return RequiresLoginException(
        message: "The provided login contained an Error: $error");
  }

  factory RequiresLoginException.noTokenType() {
    return RequiresLoginException(
        message: "The provided login contained no Token type!");
  }

  factory RequiresLoginException.noToken() {
    return RequiresLoginException(
        message: "The provided login contained no API Token!");
  }
}
