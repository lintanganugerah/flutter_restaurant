import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData icon;
  final String label;
  final Widget page;
  final Key key;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.page,
    required this.key,
  });
}
