import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/model/database/database_helper.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Setup isolasi SQLFlite
  setUpAll(() {
    sqfliteFfiInit();
    // Gunakan db in-memory (namun gaya tetap seperti SQLFlite)
    databaseFactory = databaseFactoryFfi;
  });

  final tRestaurant1 = Restaurant(
    id: 'rqdv5juczeskfw1e867',
    name: 'Melting Pot',
    description: 'Lorem ipsum dolor sit amet.',
    city: 'Medan',
    pictureId: '14',
    rating: 4.2,
  );

  final tRestaurant2 = Restaurant(
    id: 's1knt6za9kkfw1e867',
    name: 'Kafe Kita',
    description: 'Quisque rutrum. Aenean imperdiet.',
    city: 'Surabaya',
    pictureId: '25',
    rating: 4.0,
  );

  group('DatabaseHelper CRUD Test', () {
    test('should successfully insert a new favorite restaurant', () async {
      final dbHelper = DatabaseHelper();

      await dbHelper.insertFavorite(tRestaurant1);
      final result = await dbHelper.getFavorites();

      //Cek data dummy harusnya ada dalam sql
      expect(result.length, 1);
      expect(result.first.name, tRestaurant1.name);
    });

    // Skenario 2: Mengambil semua data
    test('should return all favorite restaurants from the database', () async {
      final dbHelper = DatabaseHelper();

      await dbHelper.insertFavorite(tRestaurant1);
      await dbHelper.insertFavorite(tRestaurant2);

      final result = await dbHelper.getFavorites();

      //Cek apakah kedua datanya benar masuk
      expect(result.length, 2);
      // Cek apakah ID-nya ada di dalam hasil
      expect(
        result.map((e) => e.id),
        containsAll([tRestaurant1.id, tRestaurant2.id]),
      );
    });

    test('should successfully delete a favorite restaurant', () async {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertFavorite(tRestaurant1);
      await dbHelper.insertFavorite(tRestaurant2);

      await dbHelper.deleteFavorite(tRestaurant1.id);

      final result = await dbHelper.getFavorites();

      // Seharusnya sisa 1 data setelah tRestaurant1 dihapus
      expect(result.length, 1);
      // Expect data restaurant 2 masih ada
      expect(result.first.id, tRestaurant2.id);
    });

    // Bersihkan semua data seteah test
    tearDown(() async {
      final dbHelper = DatabaseHelper();
      final favorites = await dbHelper.getFavorites();
      for (var fav in favorites) {
        await dbHelper.deleteFavorite(fav.id);
      }
    });
  });
}
