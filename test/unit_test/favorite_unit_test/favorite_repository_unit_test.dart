import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/model/database/database_helper.dart';
import 'package:restaurant_flutter/model/repositories/favorite_repository.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:sqflite_common/sqlite_api.dart';

class FakeDatabaseHelper implements DatabaseHelper {
  //Fake in memory database
  final Map<String, Restaurant> _fakeDb = {};

  // Variabel untuk melacak interaksi dari luar (dari test)
  // Dibuat untuk memudahkan mengetahui apakah method yang dipanggil benar
  bool wasGetFavoritesCalled = false;
  bool wasInsertFavoriteCalled = false;
  bool wasDeleteFavoriteCalled = false;

  @override
  Future<void> insertFavorite(Restaurant restaurant) async {
    wasInsertFavoriteCalled = true;
    _fakeDb[restaurant.id] = restaurant;
    return Future.value(); // Mengembalikan Future<void> yang selesai
  }

  @override
  Future<List<Restaurant>> getFavorites() async {
    wasGetFavoritesCalled = true;
    // Mengembalikan semua value dari map sebagai list
    return Future.value(_fakeDb.values.toList());
  }

  @override
  Future<void> deleteFavorite(String id) async {
    wasDeleteFavoriteCalled = true;
    _fakeDb.remove(id);
    return Future.value();
  }

  @override
  Future<Database?> get database => Future.value(null);
}

void main() {
  late FakeDatabaseHelper fakeDatabaseHelper;
  late FavoriteRepository repository;

  // Dummy data
  final tRestaurant = Restaurant(
    id: '1',
    name: 'Test Restaurant',
    description: 'Desc',
    pictureId: '1',
    city: 'City',
    rating: 4.5,
  );

  setUp(() {
    fakeDatabaseHelper = FakeDatabaseHelper();
    repository = FavoriteRepository(databaseHelper: fakeDatabaseHelper);
  });

  group('Favorite Repository Test (Manual Mock)', () {
    test(
      'addFavorite should call insertFavorite on the database helper',
      () async {
        await repository.addFavorite(tRestaurant);
        //Cek apakah insertFavorite pada databaseHelper terpanggil
        expect(fakeDatabaseHelper.wasInsertFavoriteCalled, isTrue);
      },
    );

    test(
      'removeFavorite should call deleteFavorite on the database helper',
      () async {
        await repository.removeFavorite('1');
        //Cek apakah data benar terhapus
        expect(fakeDatabaseHelper.wasDeleteFavoriteCalled, isTrue);
      },
    );

    test(
      'getFavorites should return data provided by the database helper',
      () async {
        await fakeDatabaseHelper.insertFavorite(tRestaurant);
        final result = await repository.getFavorites();

        // Cek apakah repository mengembalikan data yang benar
        expect(fakeDatabaseHelper.wasGetFavoritesCalled, isTrue);
        expect(result.length, 1);
        expect(result.first.id, tRestaurant.id);
      },
    );
  });
}
