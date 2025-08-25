import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_flutter/type/network_client.dart';

class HttpAdapter implements INetworkClient {
  final http.Client client;
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  HttpAdapter(this.client);

  @override
  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    return await client.get(Uri.parse('$_baseUrl/$path'), headers: headers);
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return await client.post(
      Uri.parse('$_baseUrl/$path'),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }
}
