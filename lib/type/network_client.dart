import 'dart:convert';

abstract class INetworkClient {
  Future<dynamic> get(String path, {Map<String, String>? headers});

  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
}
