import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';
import 'package:restaurant_flutter/widgets/restaurant_list_card.dart';
import 'package:restaurant_flutter/widgets/title_medium.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.query});

  final String query;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late final RestaurantViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<RestaurantViewModel>(context, listen: false);
    //Tunggu hingga build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.searchRestaurant(widget.query);
    });
  }

  @override
  void dispose() {
    _viewModel.cleanSearchRestaurantData();
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
        title: const Text("Search Result", style: TextStyle(fontSize: 12)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Consumer<RestaurantViewModel>(
          builder: (context, viewmodel, child) {
            switch (viewmodel.resultRestaurantSearch) {
              // Case Loading
              case RestaurantSearchDataLoading():
                return const Center(child: CircularProgressIndicator());

              // Case Error
              case RestaurantSearchDataError(message: final msg):
                return Center(child: Text('Terjadi suatu error: $msg'));

              // Case berhasil
              case RestaurantSearchDataLoaded(data: final restaurants):
                if (restaurants != null && restaurants.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitleMedium(text: "Kamu mencari : ${widget.query}"),
                        Text(
                          'Jumlah restaurant yang ditemukan: ${restaurants.length.toString()}',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 24),
                        Expanded(child: RestaurantListCard(data: restaurants)),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text("Tidak ada data restoran."));
                }

              // State default atau Nothing
              default:
                return const SizedBox.shrink(); // Tampilkan widget kosong
            }
          },
        ),
      ),
    );
  }
}
