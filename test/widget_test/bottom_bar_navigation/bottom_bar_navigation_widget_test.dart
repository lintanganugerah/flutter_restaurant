import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/model/customer_review.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/model/services/restaurant_services.dart';
import 'package:restaurant_flutter/navigation/bottom_nav_items_list.dart';
import 'package:restaurant_flutter/navigation/bottom_nav_screen.dart';
import 'package:restaurant_flutter/viewModel/bottom_nav_view_model.dart';
import 'package:restaurant_flutter/viewModel/favorite_view_model.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';
import 'package:restaurant_flutter/viewModel/settings_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget bottomNavbarWidgetWithProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BottomNavigationViewModel()),
      ChangeNotifierProvider<RestaurantViewModel>(
        create: (_) => FakeRestaurantViewModel(),
      ),
      ChangeNotifierProvider<FavoriteViewModel>(
        create: (_) => FakeFavoriteViewModel(),
      ),
      ChangeNotifierProvider<SettingsViewModel>(
        create: (_) => FakeSettingsViewModel(),
      ),
    ],
    child: const MaterialApp(home: BottomNavigationScreen()),
  );
}

class FakeRestaurantViewModel extends ChangeNotifier
    implements RestaurantViewModel {
  @override
  RestaurantListData get resultRestaurantList => RestaurantListDataError(
    "Buat Error Saja Agar Loading Indicator berhenti dan pumpAndSettle tidak timeout",
  );

  @override
  Future<void> getListRestaurant() async {}

  @override
  void cleanDetailRestaurantData() {}

  @override
  void cleanSearchRestaurantData() {}

  @override
  void getDetailRestaurant(String id) {}

  @override
  RestaurantDetailData get resultRestaurantDetail => RestaurantDetailDataError(
    "Buat Error Saja Agar Loading Indicator berhenti dan pumpAndSettle tidak timeout",
  );

  @override
  RestaurantSearchData get resultRestaurantSearch => RestaurantSearchDataError(
    "Buat Error Saja Agar Loading Indicator berhenti dan pumpAndSettle tidak timeout",
  );

  @override
  void searchRestaurant(String query) {}

  @override
  void updateCustomerReviews(List<CustomerReview> newReviews) {}

  @override
  void updateServices(RestaurantServices newServices) {}
}

class FakeFavoriteViewModel extends ChangeNotifier
    implements FavoriteViewModel {
  @override
  Future<void> getFavorites() {
    throw UnimplementedError();
  }

  @override
  bool isFavorite(String restaurantId) {
    throw UnimplementedError();
  }

  @override
  FavoriteState get state => FavoriteError(
    "Buat Error Saja Agar Loading Indicator berhenti dan pumpAndSettle tidak timeout",
  );

  @override
  Future<void> toggleFavorite(Restaurant restaurant) {
    throw UnimplementedError();
  }
}

class FakeSettingsViewModel extends ChangeNotifier
    implements SettingsViewModel {
  @override
  Future<void> loadSettings() {
    throw UnimplementedError();
  }

  @override
  SettingsState get state => SettingsStateError(
    "Buat Error Saja Agar Loading Indicator berhenti dan pumpAndSettle tidak timeout",
  );

  @override
  Future<void> toggleDarkMode(bool value) {
    throw UnimplementedError();
  }
}

void main() {
  //Mock Shared Preferences
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('BottomNavigationBar should display item list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(bottomNavbarWidgetWithProvider());
    await tester.pumpAndSettle();

    // Daftar item list
    final items = BottomNavItemsList.itemsList;

    // Test Widget BottomNavigationBar bawaan flutter ditampilkan
    final widgetFinder = find.byType(BottomNavigationBar);
    expect(widgetFinder, findsOneWidget);

    // Test jumlah items nya sama dengan yang ada pada BottomNavItemsList.itemsList
    final BottomNavigationBar bottomNavBar = tester.widget(widgetFinder);
    expect(bottomNavBar.items.length, items.length);

    // Test bahwa BottomNavItemsList telah ditampilkan (berdasarkan label)
    for (var i = 0; i < items.length; i++) {
      expect(bottomNavBar.items[i].label, items[i].label);
    }
  });

  testWidgets('BottomNavigationBar changes page when tapped', (tester) async {
    //Ubah jadi menggunakan key
    await tester.pumpWidget(bottomNavbarWidgetWithProvider());
    await tester.pumpAndSettle();

    //Default langsung ke home_screen
    expect(
      find.byKey(const Key('home_screen')),
      findsOneWidget,
      reason: "Seharusnya secara default menampilkan home_screen",
    );

    // Tap menu Favorites (Menggunakan Icon lebih stabil karena jarang akan diubah)
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    //Cek apakah benar di halaman favorite by key nya
    expect(
      find.byKey(const Key('favorite_screen')),
      findsOneWidget,
      reason:
          "Seharusnya menampilkan favorite_screen ketika menekan tab favorit",
    );
    //Memastikan sudah tidak di halaman ini ketika tap favorite_screen
    expect(
      find.byKey(const Key('home_screen')),
      findsNothing,
      reason:
          "Seharusnya sudah tidak menampikan home_screen ketika menekan tab favorite",
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('settings_screen')),
      findsOneWidget,
      reason:
          "Seharusnya menampilkan settings screen ketika menekan tab settings",
    );
    expect(
      find.byKey(const Key('favorite_screen')),
      findsNothing,
      reason: "Seharusnya sudah tidak menampilkan halaman favorite_screen",
    );
  });
}
