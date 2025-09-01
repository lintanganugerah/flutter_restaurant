import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurant_flutter/model/database/database_helper.dart';
import 'package:restaurant_flutter/model/network/http_adapter.dart';
import 'package:restaurant_flutter/model/repositories/favorite_repository.dart';
import 'package:restaurant_flutter/model/services/restaurant_services.dart';
import 'package:restaurant_flutter/model/services/review_services.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/model/type/network_client.dart';
import 'package:restaurant_flutter/viewModel/bottom_nav_view_model.dart';
import 'package:restaurant_flutter/viewModel/favorite_view_model.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';
import 'package:restaurant_flutter/viewModel/review_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_flutter/viewModel/settings_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<SingleChildWidget> createAppProviderList() {
  return [
    // DEPENDENSI DASAR
    // Menyediakan instance dasar yang tidak bergantung pada provider lain.
    Provider<http.Client>(create: (_) => http.Client()),
    Provider<DatabaseHelper>(create: (_) => DatabaseHelper()),

    // =======================================================================
    // SERVICES, ADAPTERS & REPOSITORIES
    // Bergantung pada dependensi dasar
    ProxyProvider<http.Client, INetworkClient>(
      update: (context, client, previous) => HttpAdapter(client),
    ),
    ProxyProvider<INetworkClient, RestaurantServices>(
      update: (context, networkClient, previous) =>
          RestaurantServices(client: networkClient),
    ),
    ProxyProvider<INetworkClient, ReviewServices>(
      update: (context, networkClient, previous) =>
          ReviewServices(client: networkClient),
    ),
    ProxyProvider<SharedPreferences, SettingsService>(
      update: (context, prefs, previous) => SettingsService(prefs),
    ),
    ProxyProvider<DatabaseHelper, FavoriteRepository>(
      update: (context, dbHelper, previous) =>
          FavoriteRepository(databaseHelper: dbHelper),
    ),

    // VIEWMODELS
    // Bergantung pada SERVICES, ADAPTERS & REPOSITORIES
    ChangeNotifierProvider(create: (context) => BottomNavigationViewModel()),
    ChangeNotifierProxyProvider<RestaurantServices, RestaurantViewModel>(
      create: (context) =>
          RestaurantViewModel(context.read<RestaurantServices>()),
      update: (context, services, previousViewModel) =>
          previousViewModel!..updateServices(services),
    ),
    ChangeNotifierProxyProvider<ReviewServices, ReviewViewModel>(
      create: (context) => ReviewViewModel(context.read<ReviewServices>()),
      update: (context, services, previousViewModel) =>
          ReviewViewModel(services),
    ),
    ChangeNotifierProxyProvider<SettingsService, SettingsViewModel>(
      create: (context) => SettingsViewModel(context.read<SettingsService>()),
      update: (context, service, previousViewModel) =>
          SettingsViewModel(service),
    ),
    ChangeNotifierProxyProvider<FavoriteRepository, FavoriteViewModel>(
      create: (context) => FavoriteViewModel(
        favoriteRepository: context.read<FavoriteRepository>(),
      ),
      update: (context, repository, previousViewModel) =>
          FavoriteViewModel(favoriteRepository: repository),
    ),
  ];
}
