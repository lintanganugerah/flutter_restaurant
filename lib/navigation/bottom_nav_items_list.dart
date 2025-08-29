import 'package:flutter/material.dart';
import 'package:restaurant_flutter/model/bottom_nav_item.dart';
import 'package:restaurant_flutter/view/home_screen.dart';
import 'package:restaurant_flutter/view/settings_screen.dart';

class BottomNavItemsList {
  static final List<BottomNavItem> itemsList = [
    BottomNavItem(
      icon: Icons.home,
      label: 'Home',
      page: const Homescreen(),
      key: Key('home_screen'),
    ),
    BottomNavItem(
      icon: Icons.favorite,
      label: 'Favorites',
      page: Placeholder(child: Center(child: const Text('Favorites Page'))),
      key: Key('favorite_screen'),
    ),
    BottomNavItem(
      icon: Icons.settings,
      label: 'Settings',
      page: const SettingsPage(),
      key: Key('settings_screen'),
    ),
  ];

  static get bottomNavItemsList => itemsList;
}
