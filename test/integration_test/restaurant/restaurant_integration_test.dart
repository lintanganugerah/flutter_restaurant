import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_flutter/model/network/http_adapter.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/model/services/restaurant_services.dart';
import 'package:http/http.dart' as http;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('RestaurantServices Integration Test', () {
    late RestaurantServices service;

    setUp(() {
      service = RestaurantServices(client: HttpAdapter(http.Client()));
    });

    testWidgets('getListRestaurants should fetch and parse data correctly', (
      tester,
    ) async {
      final result = await service.getListRestaurants();

      // Verifikasi hasilnya pemanggilan service (API)
      expect(result, isNotNull);
      expect(
        result.error,
        isFalse,
        reason: "API call should not result in an error",
      );
      expect(
        result.restaurants,
        isNotEmpty,
        reason: "The restaurant list should not be empty",
      );
      expect(
        result.restaurants.first,
        isA<Restaurant>(),
        reason: "The items in the list should be Restaurant objects",
      );
    });

    testWidgets('getDetailRestaurant should fetch a single restaurant', (
      tester,
    ) async {
      const validId = "rqdv5juczeskfw1e867";
      final result = await service.getDetailRestaurant(validId);

      // Assert
      expect(result.error, isFalse);
      expect(result.restaurant.id, validId);
      expect(result.restaurant.name, isNotNull);
    });
  });
}
