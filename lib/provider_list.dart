import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurant_flutter/model/network/http_adapter.dart';
import 'package:restaurant_flutter/model/services/restaurant_services.dart';
import 'package:restaurant_flutter/model/services/review_services.dart';
import 'package:restaurant_flutter/type/network_client.dart';
import 'package:restaurant_flutter/viewModel/bottom_nav_view_model.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';
import 'package:restaurant_flutter/viewModel/review_view_model.dart';
import 'package:http/http.dart' as http;

final INetworkClient _httpClient = HttpAdapter(http.Client());

final List<SingleChildWidget> providersList = [
  ChangeNotifierProvider(
    create: (context) =>
        RestaurantViewModel(RestaurantServices(client: _httpClient)),
  ),
  ChangeNotifierProvider(
    create: (context) => ReviewViewModel(ReviewServices(client: _httpClient)),
  ),
  ChangeNotifierProvider(create: (context) => BottomNavigationViewModel()),
];

Widget useProviderList({required Widget child}) {
  return MultiProvider(providers: providersList, child: child);
}
