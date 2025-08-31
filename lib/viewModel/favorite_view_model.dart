import 'package:flutter/widgets.dart';
import 'package:restaurant_flutter/model/restaurant.dart';

class FavoriteViewModel extends ChangeNotifier {
  final List<Restaurant> _fav = [];

  List<Restaurant> get favorites => _fav;

  bool isFavorite(String restaurantId) {
    return _fav.any((favorite) => favorite.id == restaurantId);
  }

  void toggleFavorite(Restaurant restaurant) {
    final isRemoved = _fav.remove(restaurant);
    if (!isRemoved) {
      _fav.add(restaurant);
    }
    notifyListeners();
  }
}
