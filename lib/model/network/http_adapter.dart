import 'package:http/http.dart' as http;
import 'package:restaurant_flutter/type/network_client.dart';

class HttpAdapter implements INetworkClient {
  final http.Client client;
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  HttpAdapter(this.client);

  @override
  Future<dynamic> get(String path) async {
    return await client.get(Uri.parse('$_baseUrl/$path'));
  }
}
