import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/view/favorites_restaurant_screen.dart';
import 'package:restaurant_flutter/viewModel/favorite_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget settingsPage(SharedPreferences pref) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FavoriteViewModel()),
    ],
    child: Consumer<FavoriteViewModel>(
      builder: (context, viewModel, child) {
        return MaterialApp(home: const FavoritesRestaurantScreen());
      },
    ),
  );
}

void main() {
  group("Favorite View Model", () {
    //
  });
}
