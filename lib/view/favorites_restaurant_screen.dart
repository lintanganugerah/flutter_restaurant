import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/viewModel/favorite_view_model.dart';
import 'package:restaurant_flutter/view/widgets/restaurant_list_card.dart';
import 'package:restaurant_flutter/view/widgets/title_medium.dart';

class FavoritesRestaurantScreen extends StatelessWidget {
  const FavoritesRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Consumer<FavoriteViewModel>(
                  builder: (context, viewModel, child) {
                    switch (viewModel.state) {
                      // State loading
                      case FavoriteLoading():
                        return const Center(child: CircularProgressIndicator());

                      //State Success / Loaded
                      case FavoriteLoaded(restaurants: final data):
                        if (data.isEmpty) {
                          return const Center(
                            child: Text(
                              'You dont have any favorited restaurant',
                            ),
                          );
                        } else {
                          return RestaurantListCard(data: data);
                        }

                      // State Error
                      case FavoriteError(message: final msg):
                        return Center(child: Text(msg));

                      default:
                        return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
