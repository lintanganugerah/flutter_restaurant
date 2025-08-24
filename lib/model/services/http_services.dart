class HttpServices {
  static final _baseUrl = "restaurant-api.dicoding.dev";

  Uri uri(String path, [Map<String, dynamic>? queryParameters]) {
    return Uri.https(_baseUrl, path, queryParameters);
  }
}
