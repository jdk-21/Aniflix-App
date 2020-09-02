class AniflixException implements Exception {
  String name;
  String message;

  AniflixException(this.name, this.message);

  String toString() {
    if (message == null) return name;
    return "$name: $message";
  }
}
