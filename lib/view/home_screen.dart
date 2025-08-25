import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/view/search_result_screen.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';
import 'package:restaurant_flutter/widgets/restaurant_list_card.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    //Tunggu hingga build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantViewModel>(
        context,
        listen: false,
      ).getListRestaurant();
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  void _submitSearch() {
    final String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(query: searchQuery),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text("Restaurant", style: textTheme.titleLarge),
              Text("Recommended For You", style: textTheme.titleMedium),
              const SizedBox(height: 16),
              //Search Bar
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _searchController,
                  onFieldSubmitted: (value) => _submitSearch(),
                  decoration: InputDecoration(
                    hintText: 'Cari restoran...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Card List Restoran
              Expanded(
                child: Consumer<RestaurantViewModel>(
                  builder: (context, viewmodel, child) {
                    switch (viewmodel.resultRestaurantList) {
                      // Case Loading
                      case RestaurantListDataLoading():
                        return const Center(child: CircularProgressIndicator());

                      // Case Error
                      case RestaurantListDataError(message: final msg):
                        return Center(child: Text(msg));

                      // Case berhasil
                      case RestaurantListDataLoaded(data: final restaurants):
                        if (restaurants != null && restaurants.isNotEmpty) {
                          return RestaurantListCard(data: restaurants);
                        } else {
                          return const Center(
                            child: Text("Tidak ada data restoran."),
                          );
                        }

                      // State default atau Nothing
                      default:
                        return const SizedBox.shrink(); // Tampilkan widget kosong
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
