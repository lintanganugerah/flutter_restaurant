import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/viewModel/bottom_nav_view_model.dart';

void main() {
  group("BottomNavigationBar View Model Test", () {
    test('Initial Index should be 0', () {
      final initialIndex = BottomNavigationViewModel().currentIndex;
      expect(initialIndex, 0);
    });

    test(
      'ViewModel setIndex should update currentIndex value to new index',
      () {
        final viewModel = BottomNavigationViewModel();
        final newIndex = 2;
        viewModel.setIndex(newIndex);
        expect(viewModel.currentIndex, newIndex);
      },
    );
  });
}
