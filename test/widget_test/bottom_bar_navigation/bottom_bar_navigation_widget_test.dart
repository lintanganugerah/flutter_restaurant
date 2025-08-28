import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_flutter/navigation/bottom_nav_items_list.dart';
import 'package:restaurant_flutter/navigation/bottom_nav_screen.dart';
import 'package:restaurant_flutter/provider_list.dart';

final bottomNavbarWidgetWithProvider = useProviderList(
  child: const MaterialApp(home: BottomNavigationScreen()),
);

void main() {
  testWidgets('BottomNavigationBar should display item list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(bottomNavbarWidgetWithProvider);

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
    await tester.pumpWidget(bottomNavbarWidgetWithProvider);

    // Default halaman di Home
    expect(find.text('Restaurant'), findsOneWidget);

    // Tap menu Favorites
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.text('Favorites Page'), findsOneWidget);

    // Tap menu Settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings Page'), findsOneWidget);
  });
}
