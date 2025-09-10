import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/model/customer_review.dart';
import 'package:restaurant_flutter/model/menu.dart';
import 'package:restaurant_flutter/model/type/menu_type.dart';
import 'package:restaurant_flutter/view/add_review_screen.dart';
import 'package:restaurant_flutter/viewModel/favorite_view_model.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';
import 'package:restaurant_flutter/view/widgets/card_menu.dart';
import 'package:restaurant_flutter/view/widgets/review_card.dart';
import 'package:restaurant_flutter/view/widgets/title_medium.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id});

  final String id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final RestaurantViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<RestaurantViewModel>(context, listen: false);
    //Tunggu hingga build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getDetailRestaurant(widget.id);
    });
  }

  @override
  void dispose() {
    _viewModel.cleanDetailRestaurantData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.white.withValues(alpha: 0.7),
              child: BackButton(color: Colors.black54),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<RestaurantViewModel>(
        builder: (context, viewmodel, child) {
          switch (viewmodel.resultRestaurantDetail) {
            //Case Loading
            case RestaurantDetailDataLoading():
              return const Center(child: CircularProgressIndicator());

            //Case Error
            case RestaurantDetailDataError(message: final msg):
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Terjadi suatu error: $msg',
                    textAlign: TextAlign.center,
                  ),
                ),
              );

            //Case Data Loaded / berhasil
            case RestaurantDetailDataLoaded(data: final restaurant):
              if (restaurant != null) {
                // Ambil daftar menu makanan
                final List<MenuItem> foodList = restaurant.menu!.getListByType(
                  MenuType.foods,
                );
                // Ambil daftar menu minuman
                final List<MenuItem> drinkList = restaurant.menu!.getListByType(
                  MenuType.drinks,
                );
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Header Foto
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Hero(
                            tag: restaurant.pictureId,
                            child: Image.network(
                              "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      //Bagian Informasi Restoran
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Nama Restoran
                            Row(
                              children: [
                                Expanded(
                                  child: TitleMedium(text: restaurant.name),
                                ),
                                Selector<FavoriteViewModel, bool>(
                                  selector: (context, viewModel) =>
                                      viewModel.isFavorite(restaurant.id),

                                  builder: (context, isFav, child) {
                                    return IconButton(
                                      onPressed: () {
                                        context
                                            .read<FavoriteViewModel>()
                                            .toggleFavorite(restaurant);
                                      },
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: isFav
                                            ? Colors.redAccent
                                            : Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            //Info lokasi
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${restaurant.address}, ${restaurant.city}',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            //Info Kategori
                            SizedBox(
                              height: 25,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.category,
                                    color: Colors.grey[600],
                                    size: 16,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: restaurant.categories?.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final categoriesIndex =
                                                restaurant.categories?[index];
                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4.0,
                                                    ),
                                                child: Text(
                                                  categoriesIndex?.name ??
                                                      'No Data',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey[600],
                                                      ),
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Rating
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant.rating.toString(),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            //Review Card
                            TitleMedium(
                              text: "Review",
                              fontWeight: FontWeight.w300,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: restaurant.customerReviews!.map((
                                  review,
                                ) {
                                  return Container(
                                    width: 300,
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: ReviewCard(review: review),
                                  );
                                }).toList(),
                              ),
                            ),
                            //Deskripsi
                            TitleMedium(
                              text: "Deskripsi",
                              fontWeight: FontWeight.w300,
                            ),
                            Text(
                              restaurant.description,
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 24),
                            //Menu
                            TitleMedium(
                              text: "Menu",
                              fontWeight: FontWeight.w300,
                            ),
                            Column(
                              children: [
                                CardMenu(data: foodList, type: MenuType.foods),
                                SizedBox(height: 20),
                                CardMenu(
                                  data: drinkList,
                                  type: MenuType.drinks,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text("Data Restoran tidak ditemukan"),
                );
              }

            //Default jika data masih kosong
            default:
              return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: Consumer<RestaurantViewModel>(
        builder: (context, viewmodel, child) {
          switch (viewmodel.resultRestaurantDetail) {
            case RestaurantDetailDataLoaded(data: final restaurant):
              return FloatingActionButton(
                onPressed: () async {
                  //Menunggu hasil dari screen add review
                  final result = await Navigator.of(context)
                      .push<List<CustomerReview>>(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddReviewScreen(
                              id: restaurant!.id,
                              restaurantName: restaurant.name,
                              pictureId: restaurant.pictureId,
                            );
                          },
                        ),
                      );

                  // Update Review jika ada hasil dari screen
                  if (result != null && mounted) {
                    _viewModel.updateCustomerReviews(result);
                  }
                },
                child: const Icon(Icons.reviews),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
