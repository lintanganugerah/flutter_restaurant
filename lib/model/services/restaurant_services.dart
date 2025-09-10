import 'dart:convert';

import 'package:http/http.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/model/type/network_client.dart';

class RestaurantServices {
  final INetworkClient client;

  RestaurantServices({required this.client});

  Future<RestaurantListResponse> getListRestaurants() async {
    try {
      final response = await client.get('list');
      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal Memuat Data Restaurant. Harap Coba Lagi Nanti. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ClientException) {
        throw Exception(
          "Tidak Dapat Terhubung ke Internet. Harap Cek Koneksi Anda",
        );
      }
      throw Exception(e.toString());
    }
  }

  Future<RestaurantDetailResponse> getDetailRestaurant(String id) async {
    try {
      final response = await client.get('detail/$id');
      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal Memuat Data Restaurant. Harap Coba Lagi Nanti. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ClientException) {
        throw Exception(
          "Tidak Dapat Terhubung ke Internet. Harap Cek Koneksi Anda",
        );
      }
      throw Exception(e.toString());
    }
  }

  Future<RestaurantSearchResponse> searchRestaurants(String query) async {
    try {
      final response = await client.get('search?q=$query');
      if (response.statusCode == 200) {
        return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal Memuat Data Restaurant. Harap Coba Lagi Nanti. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ClientException) {
        throw Exception(
          "Tidak Dapat Terhubung ke Internet. Harap Cek Koneksi Anda",
        );
      }
      throw Exception(e.toString());
    }
  }
}
