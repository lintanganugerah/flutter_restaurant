import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/model/database/database_helper.dart';
import 'package:restaurant_flutter/model/repositories/favorite_repository.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/view/favorites_restaurant_screen.dart';
import 'package:restaurant_flutter/view/widgets/restaurant_list_card.dart';
import 'package:restaurant_flutter/viewModel/favorite_view_model.dart';

Widget favoritePage({FavoriteViewModel? viewModel}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) =>
            viewModel ??
            FavoriteViewModel(favoriteRepository: FakeFavoriteRepository()),
      ),
    ],
    child: Consumer<FavoriteViewModel>(
      builder: (context, viewModel, child) {
        return MaterialApp(home: const FavoritesRestaurantScreen());
      },
    ),
  );
}

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
    testWidgets(
      "Should display a loading indicator when loading for the first time.",
      (WidgetTester tester) async {
        await tester.pumpWidget(favoritePage());
        final loadingIndicator = find.byType(CircularProgressIndicator);
        expect(loadingIndicator, findsOneWidget);
      },
    );

    testWidgets(
      "Should display a text widget message when there are no preferred restaurants.",
      (WidgetTester tester) async {
        await tester.pumpWidget(favoritePage());
        await tester.pumpAndSettle();

        final textMessage = find.text("You dont have any favorited restaurant");
        expect(textMessage, findsOneWidget);
      },
    );

    testWidgets(
      "Should display the restaurant card widget if there is a favorite restaurant",
      (WidgetTester tester) async {
        final viewModel = FavoriteViewModel(
          favoriteRepository: FakeFavoriteRepository(),
        );
        final restaurant1 = Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Lorem ipsum dolor sit amet.',
          city: 'Medan',
          pictureId: '14',
          rating: 4.2,
        );
        viewModel.toggleFavorite(restaurant1);
        await tester.pumpWidget(favoritePage(viewModel: viewModel));
        await tester.pumpAndSettle();

        final restaurantCard = find.byType(RestaurantListCard);
        expect(restaurantCard, findsOneWidget);
      },
    );
  });
}
