import 'package:flutter/material.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/widgets/restaurant_list_card.dart';
import 'package:restaurant_flutter/widgets/title_medium.dart';

class FavoritesRestaurantScreen extends StatelessWidget {
  const FavoritesRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Restaurant> listItems = List.generate(
      3,
      (index) => Restaurant(
        id: index.toString(),
        name: "Restaurant",
        description: "Desc",
        city: "City",
        pictureId: index.toString(),
        rating: 5,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TitleMedium(text: "Favorites"),
              const SizedBox(height: 24),
              Expanded(child: RestaurantListCard(data: listItems)),
            ],
          ),
        ),
      ),
    );
  }
}
