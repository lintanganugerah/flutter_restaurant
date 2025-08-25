import 'dart:convert';
import 'package:restaurant_flutter/model/customer_review.dart';
import 'package:restaurant_flutter/type/network_client.dart';

class ReviewServices {
  final INetworkClient client;

  ReviewServices({required this.client});

  Future<AddReviewResponse> postReviewRestaurant(
    Map<String, Object> body,
  ) async {
    try {
      print(body);
      final response = await client.post('review', body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddReviewResponse.fromJson(jsonDecode(response.body));
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');

        throw Exception(
          'Failed to add review. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error Internal: $e');
    }
  }
}
