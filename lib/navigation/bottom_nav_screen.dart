import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/navigation/bottom_nav_items_list.dart';
import 'package:restaurant_flutter/viewModel/bottom_nav_view_model.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationViewModel>(
      builder: (context, viewModel, child) {
        final item = BottomNavItemsList.itemsList[viewModel.currentIndex];
        return Scaffold(
          body: item.page,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: viewModel.currentIndex,
            items: BottomNavItemsList.itemsList
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  ),
                )
                .toList(),
            onTap: viewModel.setIndex,
            key: item.key,
          ),
        );
      },
    );
  }
}
