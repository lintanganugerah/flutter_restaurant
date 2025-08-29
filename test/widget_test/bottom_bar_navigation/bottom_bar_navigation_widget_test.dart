import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/navigation/bottom_nav_items_list.dart';
import 'package:restaurant_flutter/navigation/bottom_nav_screen.dart';
import 'package:restaurant_flutter/app_provider_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget bottomNavbarWidgetWithProvider(sharedPreferences) {
  return MultiProvider(
    providers: createAppProviderList(sharedPreferences: sharedPreferences),
    child: const MaterialApp(home: BottomNavigationScreen()),
  );
}

void main() {
  //Mock Shared Preferences
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('BottomNavigationBar should display item list', (
    WidgetTester tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(bottomNavbarWidgetWithProvider(prefs));
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
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(bottomNavbarWidgetWithProvider(prefs));
    await tester.pumpAndSettle();

    //Default langsung ke home_screen
    expect(find.byKey(const Key('home_screen')), findsOneWidget);

    // Tap menu Favorites (Menggunakan Icon lebih stabil karena jarang akan diubah)
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    //Cek apakah benar di halaman favorite by key nya
    expect(find.byKey(const Key('favorite_screen')), findsOneWidget);
    //Memastikan sudah tidak di halaman ini ketika tap favorite_screen
    expect(find.byKey(const Key('home_screen')), findsNothing);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings_screen')), findsOneWidget);
    expect(find.byKey(const Key('favorite_screen')), findsNothing);
  });
}
