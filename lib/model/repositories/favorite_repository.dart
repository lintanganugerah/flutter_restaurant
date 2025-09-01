import '../database/database_helper.dart';
import '../restaurant.dart';

class FavoriteRepository {
  final DatabaseHelper databaseHelper;

  FavoriteRepository({required this.databaseHelper});

  Future<List<Restaurant>> getFavorites() {
    return databaseHelper.getFavorites();
  }

  Future<void> addFavorite(Restaurant restaurant) {
    return databaseHelper.insertFavorite(restaurant);
  }

  Future<void> removeFavorite(String id) {
    return databaseHelper.deleteFavorite(id);
  }
}
