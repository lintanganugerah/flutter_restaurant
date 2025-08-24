import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/model/services/http_services.dart';

class RestaurantServices {
  final HttpServices httpServices;

  RestaurantServices({required this.httpServices});

  Future<RestaurantListResponse> getListRestaurants() async {
    try {
      final response = await http.get(httpServices.uri('/list'));
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
      final response = await http.get(httpServices.uri('/detail/$id'));
      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Error Internal : ${e.toString()}');
    }
  }
}
