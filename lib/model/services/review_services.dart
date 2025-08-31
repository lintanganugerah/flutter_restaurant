import 'dart:convert';
import 'package:http/http.dart';
import 'package:restaurant_flutter/model/customer_review.dart';
import 'package:restaurant_flutter/model/type/network_client.dart';

class ReviewServices {
  final INetworkClient client;

  ReviewServices({required this.client});

  Future<AddReviewResponse> postReviewRestaurant(
    Map<String, Object> body,
  ) async {
    try {
      final response = await client.post('review', body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddReviewResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal menambahkan review. Harap Coba Kembali Nanti. Status code: ${response.statusCode}',
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
