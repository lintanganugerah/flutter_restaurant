import 'package:restaurant_flutter/model/category.dart';
import 'package:restaurant_flutter/model/customer_review.dart';
import 'package:restaurant_flutter/model/menu.dart';

class Restaurant {
  String id;
  String name;
  String description;
  String city;
  String pictureId;
  double rating;

  // Data dari API detail
  String? address;
  List<Category>? categories;
  Menu? menu;
  List<CustomerReview>? customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.pictureId,
    required this.rating,
    // Data di bawah ini akan ada jika dari API details sehingga opsional
    this.address,
    this.categories,
    this.menu,
    this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    city: json["city"],
    pictureId: json["pictureId"],
    rating: json["rating"]?.toDouble(),
    // Cek jika key ada sebelum parsing, jika tidak, akan null
    address: json["address"],
    categories: json["categories"] == null
        ? null
        : List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x)),
          ),
    menu: json["menus"] == null ? null : Menu.fromJson(json["menus"]),
    customerReviews: json["customerReviews"] == null
        ? null
        : List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
          ),
  );

  /// hashCode-nya kita ubah berdasarkan id agar operator di bawah ini paham
  @override
  int get hashCode => id.hashCode;

  /// Dengan kode ini, kita memberitahu Dart sebuah aturan baru:
  /// Objek Restaurant dianggap sama berdasarkan properti 'id' bukan berdasarkan memori
  @override
  bool operator ==(Object other) {
    return other is Restaurant && other.id == id;
  }
}

class RestaurantListResponse {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantListResponse(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x)),
        ),
      );
}

class RestaurantSearchResponse {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  RestaurantSearchResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearchResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantSearchResponse(
        error: json["error"],
        founded: json["founded"] ?? 0,
        restaurants: json["restaurants"] == null
            ? []
            : List<Restaurant>.from(
                json["restaurants"].map((x) => Restaurant.fromJson(x)),
              ),
      );
}

class RestaurantDetailResponse {
  bool error;
  String message;
  Restaurant restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailResponse(
        error: json["error"],
        message: json["message"],
        restaurant: Restaurant.fromJson(json["restaurant"]),
      );
}
