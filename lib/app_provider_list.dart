import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurant_flutter/model/network/http_adapter.dart';
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

final INetworkClient _httpClient = HttpAdapter(http.Client());

List<SingleChildWidget> createAppProviderList({
  required SharedPreferences sharedPreferences,
}) {
  return [
    ChangeNotifierProvider(
      create: (context) =>
          RestaurantViewModel(RestaurantServices(client: _httpClient)),
    ),
    ChangeNotifierProvider(
      create: (context) => ReviewViewModel(ReviewServices(client: _httpClient)),
    ),
    ChangeNotifierProvider(create: (context) => BottomNavigationViewModel()),
    ChangeNotifierProvider(
      create: (context) =>
          SettingsViewModel(SettingsService(sharedPreferences)),
    ),
    ChangeNotifierProvider(create: (context) => FavoriteViewModel()),
  ];
}
