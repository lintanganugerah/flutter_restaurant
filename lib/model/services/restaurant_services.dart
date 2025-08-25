import 'dart:convert';

import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/type/network_client.dart';

class RestaurantServices {
  final INetworkClient client;

  RestaurantServices({required this.client});

  Future<RestaurantListResponse> getListRestaurants() async {
    try {
      final response = await client.get('list');
      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Error Internal: $e');
    }
  }

  Future<RestaurantDetailResponse> getDetailRestaurant(String id) async {
    try {
      final response = await client.get('detail/$id');
      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Error Internal : ${e.toString()}');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurants(String query) async {
    try {
      final response = await client.get('search?q=$query');
      if (response.statusCode == 200) {
        return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Error Internal: $e');
    }
  }
}
