import 'package:flutter/widgets.dart';
import 'package:restaurant_flutter/model/repositories/favorite_repository.dart';
import 'package:restaurant_flutter/model/restaurant.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoriteRepository _repository;

  FavoriteState _state = FavoriteInitial();

  FavoriteState get state => _state;

  // melacak ID item yang sedang proses toggle favorit
  String? _togglingId;

  String? get togglingId => _togglingId;

  FavoriteViewModel({required FavoriteRepository favoriteRepository})
    : _repository = favoriteRepository {
    getFavorites();
  }

  // Mengambil daftar favorit dan mengubah state sesuai hasilnya.
  Future<void> getFavorites() async {
    // Ubah state menjadi Loading sebelum memuat
    _emit(FavoriteLoading());

    try {
      final result = await _repository.getFavorites();
      _emit(FavoriteLoaded(result));
    } catch (e) {
      print(e);
      _emit(FavoriteError('Failed to load favorites data.'));
    }
    notifyListeners();
  }

  bool isFavorite(String restaurantId) {
    final currentState = _state;
    if (currentState is FavoriteLoaded) {
      return currentState.restaurants.any((fav) => fav.id == restaurantId);
    }
    return false;
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    final isFavorited = isFavorite(restaurant.id);
    _togglingId = restaurant.id;
    notifyListeners();
    try {
      if (isFavorited) {
        await _repository.removeFavorite(restaurant.id);
      } else {
        await _repository.addFavorite(restaurant);
      }
      // Setelah toggle, muat ulang data
      await getFavorites();
    } catch (e) {
      _emit(FavoriteError('Failed to favorite this items'));
    } finally {
      // Hapus status toggle setelah selesai
      _togglingId = null;
    }
  }

  _emit(FavoriteState state) {
    _state = state;
    notifyListeners();
  }
}

// Sealed class utama
sealed class FavoriteState {}

// State Awal, sebelum ada aksi apa pun, dan masih kosong
class FavoriteInitial extends FavoriteState {}

// State saat sedang memuat data dari database
class FavoriteLoading extends FavoriteState {}

// Berhasil ambil data
class FavoriteLoaded extends FavoriteState {
  final List<Restaurant> restaurants;

  FavoriteLoaded(this.restaurants);
}

// Terjadi error
class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);
}
