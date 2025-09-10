import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/model/database/database_helper.dart';
import 'package:restaurant_flutter/model/repositories/favorite_repository.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/viewModel/favorite_view_model.dart';

final restaurant1 = Restaurant(
  id: 'rqdv5juczeskfw1e867',
  name: 'Melting Pot',
  description: 'Lorem ipsum dolor sit amet.',
  city: 'Medan',
  pictureId: '14',
  rating: 4.2,
);

final restaurant2 = Restaurant(
  id: 's1knt6za9kkfw1e867',
  name: 'Kafe Kita',
  description: 'Quisque rutrum. Aenean imperdiet.',
  city: 'Gorontalo',
  pictureId: '25',
  rating: 4,
);

class FakeFavoriteRepository implements FavoriteRepository {
  final List<Restaurant> fakeFavorites = [];

  @override
  Future<List<Restaurant>> getFavorites() async {
    return Future.value(fakeFavorites);
  }

  @override
  Future<void> addFavorite(Restaurant restaurant) async {
    fakeFavorites.removeWhere((item) => item.id == restaurant.id);
    fakeFavorites.add(restaurant);
  }

  @override
  Future<void> removeFavorite(String id) async {
    fakeFavorites.removeWhere((item) => item.id == id);
  }

  @override
  DatabaseHelper get databaseHelper => throw UnimplementedError();
}

void main() {
  group("Favorite View Model", () {
    late FavoriteViewModel viewModel;
    // Ini memastikan setiap test dimulai dengan kondisi yang bersih dengan instance baru.
    setUp(() {
      viewModel = FavoriteViewModel(
        favoriteRepository: FakeFavoriteRepository(),
      );
    });

    test(
      'should add a restaurant to favorites when toggleFavorite is called',
      () {
        viewModel.toggleFavorite(restaurant1);
        final state = viewModel.state as FavoriteLoaded;

        // Cek apakah list favorites sekarang berisi restaurant1.
        expect(state.restaurants.contains(restaurant1), isTrue);
        expect(state.restaurants.length, 1);
      },
    );

    test('should remove a restaurant from favorites if it already exists', () {
      // Tambahkan restaurant1 terlebih dahulu dan cek apakah ada
      viewModel.toggleFavorite(restaurant1);
      final state = viewModel.state as FavoriteLoaded;
      expect(state.restaurants.contains(restaurant1), isTrue);

      // Panggil lagi toggleFavorite untuk restaurant yang sama untuk menghapusnya.
      viewModel.toggleFavorite(restaurant1);

      // Cek apakah list favorites sekarang sudah tidak menyimpan restaurant1.
      expect(state.restaurants.contains(restaurant1), isFalse);
      expect(state.restaurants.isEmpty, isTrue);
    });

    test('isFavorite should return true for a favorite restaurant', () {
      viewModel.toggleFavorite(restaurant1);

      // Cek apakah isFavorite mengembalikan true untuk id restaurant1.
      expect(viewModel.isFavorite(restaurant1.id), isTrue);
    });

    test('isFavorite should return false for a non-favorite restaurant', () {
      // Arrange: Tambahkan restaurant1, tapi kita akan cek untuk restaurant2.
      viewModel.toggleFavorite(restaurant1);

      // Periksa apakah isFavorite mengembalikan false untuk id restaurant2 (tidak di favorit)
      expect(viewModel.isFavorite(restaurant2.id), isFalse);
      // isFavorite harus mengembalikan false jika menggunakan id lain
      expect(viewModel.isFavorite('id-random'), isFalse);
    });
  });
}
